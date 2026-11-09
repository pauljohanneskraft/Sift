# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Sift is a Swift Package (no external dependencies) that provides a KeyPath- and result-builder-based DSL for building **predicates** (`\.price < 5 && \.stock > 0`) and **sort orders** (`Ascending(\.name).then(Descending(\.price))`). It has two library products:

- `Sift` is pure Swift; it must never import Foundation, and CI builds it on Linux to check that. It defines the DSL and evaluates it in memory with `filter(by:)`, `filterPredicate { }`, `sorted(by:)` and `sortedOrder { }`.
- `SiftFoundation` re-exports `Sift`, but not Foundation, and converts the same values into `NSPredicate`, `NSSortDescriptor` and `SortDescriptor`. It also evaluates the string operators in memory, so their results match `NSPredicate` exactly.

## Commands

```sh
swift build --build-tests -Xswiftc -warnings-as-errors   # CI requires a warning-free build
swift test
swift test --filter SiftTests.PredicateBuilderTests                     # one class
swift test --filter SiftTests.PredicateBuilderTests/testIfElse          # one test
xcodebuild -scheme Sift-Package -destination 'generic/platform=iOS' build
xcodebuild docbuild -scheme Sift-Package -destination 'generic/platform=macOS'
```

CI (`.github/workflows/ci.yml`) runs all of the above, plus `swift build --target Sift` on Linux.

## Architecture: syntax trees and backends

The main design idea spans many files. **The `Sift` target defines DSL values as inert, phantom-typed syntax trees. Each backend gives them meaning through conditional conformances.**

- **Predicates** (`Sources/Sift/Predicates/`):
  - `protocol SiftPredicate<Root>` has two associated types, `Root` and `Operator`. It is deliberately not named `Predicate`, because Foundation's `Predicate` would collide with it.
  - The nodes are:
    - `BinaryPredicate`, used through the typealiases `And`, `Or`, `Xor` and `Nand`, as in `Xor(a, b)`;
    - `UnaryPredicate`, used through `Not`;
    - `BooleanPredicate`;
    - `EitherPredicate`, produced by `if`/`else` in builders;
    - `PredicateGroup`, used through `AllOf` and `AnyOf`;
    - the leaf nodes `KeyPathValuePredicateValue`, `KeyPathKeyPathPredicateValue`, `StringPredicateValue` and `MembershipPredicateValue`.
- **Operators are empty marker types**: `AndOperator`, `EqualOperator<Value>`, `OptionalComparison<Base>`, `ContainsOperator` and so on. The global `==`, `<`, `&&`, `!` and similar overloads build the nodes. When the value is on the left, as in `value < \.kp`, the comparison is stored with the operator flipped (here as GreaterThan).
- **Orders** (`Sources/Sift/Orders/`): `Ascending`, `Descending`, `Reverse`, `ConcatenatedOrder` (built with `.then` or `OrderBuilder`), `OptionalKeyPathOrder`, and `Array` of orders.
- **Backends**: each backend is a protocol plus conditional conformances on every node and operator. They live in files named `<BackendProtocol>+<Node>.swift`.
  - **In memory**: `SwiftEvaluablePredicate`, `SwiftEvaluableOrder` and their `…Operator` protocols, in `Sources/Sift/Swift/`.
  - **`NSPredicate`**: `NSPredicateConvertible`, in `Sources/SiftFoundation/Predicate/`.
  - **Sort descriptors**: `SortDescriptorsConvertible`, `SortDescriptorsConvertibleOperator` and `SortDescriptorUsableValue`, in `Sources/SiftFoundation/Orders/`.

Consequences when changing code:

- **Adding an operator** takes three things: a marker type, a builder function or operator overload, and one conformance **per backend**. If a backend conformance is missing, the expression still compiles, but it fails at that backend's call site.
- **Value constraints** such as `Equatable` are declared in the backend conformances, not in the DSL. The one exception is that the ordering operators (`<`, `<=`, `>`, `>=`) require `Value: Comparable` in the DSL, so they never compete with the optional overloads (see below). The `NSPredicate` conformances mirror the Swift ones on purpose, so both backends accept the same expressions.
- **Value operators in `NSPredicate`**: `NSPredicateConvertibleValueOperator` has the two `predicate(for:and:)` requirements as customization points, and `NSComparisonPredicateValueOperator` derives them from a `comparisonType`. `OptionalComparison` overrides them to add nil guards.
- **`NSPredicateUsableValue` is an allowlist** of value types key-value coding can represent; every `NSPredicate` value conformance requires it, and its `nsPredicateConstant` bridges constants (optionals unwrap, `RawRepresentable` uses the raw value). Types outside it, such as `Decimal`, which crashes inside KVC, fail to compile. `@objc enum`s opt in with an empty conformance.
- **In-memory comparison semantics**: in-memory `==`, `<`, `OneOf` and keypath orders go through `SiftComparison` (`Sources/Sift/Swift/SiftCustomComparable.swift`), which checks at runtime for a `SiftCustomComparable` conformance. `SiftFoundation` conforms `String` (`NSString.isEqual(to:)` and `compare(_:)`), `Double`, `Float` and `CGFloat` (`NSNumber.compare(_:)` for NaN), so both backends agree exactly; this is what NSPredicate was probed to do. Note that `swift test` links SiftFoundation into the same process, so `SiftTests` also run with these semantics.
- **Generated `NSPredicate`s go through helpers** in `NSPredicateConvertible.swift`: `keyPathExpression` (stops with a message for non-`@objc` keypaths), `constantExpression`, `comparison`, and `compoundPredicate`, which flattens nested AND/OR and drops the identity constants that false `if`s produce. `Xor` uses `TERNARY(A, 1, 0) != TERNARY(B, 1, 0)` so operands aren't duplicated; Core Data's SQLite store supports it.
- **Foundation conversions require `Root: NSObject`** and `@objc` properties, because they go through key-value coding. A Swift-only type such as `Int?` can't appear in a converted predicate.
- **Orders compare three-way**: `SwiftEvaluableOrder` has `compare(_:_:) -> SiftOrdering` with a default built from `isLessThan`; built-in orders implement it so `.then` chains and arrays read each value once.
- **Availability**: only the members that create `SortDescriptor` are `@available(macOS 12, …)`; conformances aren't gated, so `nsSortDescriptors` works on every OS version.
- **A new sortable value type** needs a `SortDescriptorUsableValue` and `SortDescriptorUsableOptionalWrapped` conformance in `SortDescriptorUsableValue+Conformances.swift`.

## Type-inference rules (learned the hard way)

- **A generic type that can be nested in a builder must take `Root` as its own generic parameter**, as `PredicateGroup<Root, Content, Combinator>`, `BinaryPredicate<Root, First, Second, Operator>`, `UnaryPredicate<Root, Content, Operator>` and `Reverse<Root, O>` do. If `Root` is only a typealias derived from `Content.Root` or `O.Root`, the enclosing builder can't propagate the root, and `\.member` fails with "cannot infer key path type".
- **A `\.member` literal needs a concrete `KeyPath<Root, Value>` parameter.** A parameter that is only constrained by a protocol, like `init(_ op: Operator)`, isn't enough. That is why `Ascending`, `Descending` and `Reverse` have dedicated keypath initializers.
- **The generic keypath initializers, and `init(_ op:)` on `Ascending`, `Descending` and `Reverse`, are marked `@_disfavoredOverload`**, so that the `KeyPath<Root, Wrapped?>` overloads win for optional values, also in `let order = Ascending(\Item.rating)` outside any call.
- **`PredicateGroupBuilder.buildExpression(Bool)` is `@_disfavoredOverload`.** Otherwise `\Item.a == \Item.b` in a builder resolves to the standard library's `AnyKeyPath ==` and becomes a constant.
- **Type-checking performance of `&&` chains: don't add overloads of `<`, `==`, `&&` and friends lightly.** Every overload is a candidate for every term of every chain, optional or not.
  - Budget: on Swift 6.0 to 6.2, `main` compiles 7-term chains and fails at 9. Only 4 optional ordering overloads fit in that budget (keypath vs value); value-on-the-left and two-optional-keypath forms were removed for it, and are built explicitly as `KeyPathKeyPathPredicateValue<Root, OptionalComparison<…>>`. Swift 6.4 also handles 9 terms.
  - `BinaryPredicate<Root, …>` and `UnaryPredicate<Root, …>` take `Root` as a generic parameter, which lets Swift 6.4 resolve each keypath literal locally.
  - `PredicateEvaluationTests.testLongChainTypeChecks` guards this (9 terms only under `#if compiler(>=6.4)`), and CI's Linux job compiles the core tests with Swift 6.0.
  - To measure, reproduce older compilers with Docker: `docker run --rm -v "$PWD":/src:ro swift:6.2 bash -c 'cp -r /src /w && cd /w && swift build --target SiftTests'`. For deterministic local comparisons, use `swiftc -typecheck -stats-output-dir <dir> …` and read `Sema.NumConstraintScopes`. Wall-clock timings are noisy, and single-file `swiftc` runs don't reproduce SwiftPM failures reliably.
- **Array literals of orders in `OrderBuilder`** need the element-specific `buildExpression` overloads (`[Ascending<Root, KeyPath<Root, Value>>]` and friends). With only a generic element type, the type checker can't infer the root of several keypath literals in one array ("failed to produce diagnostic").
- **Sift's `sorted(by: KeyPath)` overloads are `@_disfavoredOverload`**, so an app's own keypath sort helper wins instead of being ambiguous (`ClientHelperCompatibilityTests`).
- **Mark an intentional cross-module conformance with module-qualified names**, as in `extension Sift.StringPredicateValue: Sift.SwiftEvaluablePredicate`. This silences the retroactive-conformance warning (SE-0364).

## Tests

- **`Tests/SiftFoundationTests/ParityAssertions.swift`** holds two helpers:
  - `assertPredicateParity` checks that in-memory evaluation and `NSPredicate` evaluation select the same `Fixture`s.
  - `assertOrderParity` checks that Swift sorting, `SortDescriptor` and `NSSortDescriptor` produce the same order.
  - Use them for every new feature. Agreement between the backends is the main correctness guarantee.
- **`ReadmeExamplesTests.swift`** in both test targets mirrors the README's code. Update the two together.
- **Tools version**: keep `swift-tools-version: 5.7` and XCTest. The code relies on primary associated types and `buildPartialBlock`, and swift-testing would require 6.0.
- **Availability**: Foundation sort-descriptor APIs are annotated `@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)`. Use the same annotation for new ones.
