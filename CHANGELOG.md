# Changelog

## 1.0.0

First release. Earlier commits on `main` were never tagged, but if you used them, these
changes break source compatibility:

### Breaking changes

- `Predicate` is renamed to `SiftPredicate`, so it no longer collides with Foundation's
  `Predicate`. The empty `PredicateValue` protocol is removed.
- `SiftFoundation` re-exports `Sift`, but no longer Foundation. Add `import Foundation`
  where you use Foundation types.
- The predicate builder is replaced by `AllOf { }` and `AnyOf { }`, with `if`/`else`
  support, plus `filterPredicate { }` and `NSPredicate.build(for:) { }`.
- `BinaryPredicate`, `UnaryPredicate` and their typealiases `And`, `Or`, `Xor`, `Nand` and
  `Not` take `Root` as their first generic parameter. `Xor(a, b)` is unchanged; explicit
  spellings such as `And<A, B>` become `And<Root, A, B>`.
- `Reverse` takes `Root` as a generic parameter, and `Reverse(order:)` is `Reverse(_:)`.
- `<`, `<=`, `>` and `>=` require a `Comparable` value or an optional of one.
- `NSPredicateConvertibleValueOperator` requires `predicate(for:and:)` for both forms. For a
  plain comparison, conform to `NSComparisonPredicateValueOperator` and provide
  `comparisonType`.
- `NSPredicate` and sort-descriptor conversions only accept value types listed by
  `NSPredicateUsableValue`. `Decimal` no longer compiles, because it crashes inside
  key-value coding; use `NSDecimalNumber`. `@objc enum`s need
  `extension MyEnum: NSPredicateUsableValue {}`.
- `SwiftEvaluableOrder` has a `compare(_:_:) -> SiftOrdering` requirement with a default
  implementation, so existing conformances keep compiling.
- `sortDescriptors` and `nsSortDescriptors` are no longer available on every
  `RandomAccessCollection`, only on arrays of orders.

### Fixes

- `||` produced an `NSPredicate` AND.
- `Reverse` produced the wrong `SortDescriptor` direction.
- `\Item.a == \Item.b` inside a predicate builder became a constant.
- In-memory evaluation now agrees with `NSPredicate` and the sort descriptors for string
  matching inside grapheme clusters, string equality and ordering, NaN, optional
  comparisons where both sides are `nil`, `OneOf` with `nil`, `@objc enum` constants, and
  string comparators with a reversed order.
- Long `&&` chains type-check quickly again.
- `nsSortDescriptors` works on OS versions before macOS 12 and iOS 15.
- Converting a keypath to a non-`@objc` property stops with a message that names it.

### Additions

- Ordering comparisons and sorting on optional properties.
- `Contains`, `HasPrefix`, `HasSuffix` and `OneOf`.
- Sort descriptors for every integer type, `Float`, `Double`, `Date`, `UUID` and their
  optionals.
- Array literals of orders in `OrderBuilder`, such as `[Ascending(\.price), Ascending(\.discount)]`.
- DocC documentation and CI.
