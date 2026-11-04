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
- **Value constraints** such as `Comparable` and `Equatable` are declared in the backend conformances, not in the DSL. The `NSPredicate` conformances mirror the Swift ones on purpose, so both backends accept the same expressions.
- **Foundation conversions require `Root: NSObject`** and `@objc` properties, because they go through key-value coding. A Swift-only type such as `Int?` can't appear in a converted predicate.
- **A new sortable value type** needs a `SortDescriptorUsableValue` and `SortDescriptorUsableOptionalWrapped` conformance in `SortDescriptorUsableValue+Conformances.swift`.

## Type-inference rules (learned the hard way)

- **A generic type that can be nested in a builder must take `Root` as its own generic parameter**, as `PredicateGroup<Root, Content, Combinator>` and `Reverse<Root, O>` do. If `Root` is only a typealias derived from `Content.Root` or `O.Root`, the enclosing builder can't propagate the root, and `\.member` fails with "cannot infer key path type".
- **A `\.member` literal needs a concrete `KeyPath<Root, Value>` parameter.** A parameter that is only constrained by a protocol, like `init(_ op: Operator)`, isn't enough. That is why `Ascending`, `Descending` and `Reverse` have dedicated keypath initializers.
- **The generic keypath initializers are marked `@_disfavoredOverload`**, so that the `KeyPath<Root, Wrapped?>` overloads win for optional values instead of being ambiguous.
- **Mark an intentional cross-module conformance with module-qualified names**, as in `extension Sift.StringPredicateValue: Sift.SwiftEvaluablePredicate`. This silences the retroactive-conformance warning (SE-0364).

## Tests

- **`Tests/SiftFoundationTests/ParityAssertions.swift`** holds two helpers:
  - `assertPredicateParity` checks that in-memory evaluation and `NSPredicate` evaluation select the same `Fixture`s.
  - `assertOrderParity` checks that Swift sorting, `SortDescriptor` and `NSSortDescriptor` produce the same order.
  - Use them for every new feature. Agreement between the backends is the main correctness guarantee.
- **`ReadmeExamplesTests.swift`** in both test targets mirrors the README's code. Update the two together.
- **Tools version**: keep `swift-tools-version: 5.7` and XCTest. The code relies on primary associated types and `buildPartialBlock`, and swift-testing would require 6.0.
- **Availability**: Foundation sort-descriptor APIs are annotated `@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)`. Use the same annotation for new ones.
