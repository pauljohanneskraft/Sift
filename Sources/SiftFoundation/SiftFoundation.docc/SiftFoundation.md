# ``SiftFoundation``

Convert Sift predicates and orders into `NSPredicate`, `NSSortDescriptor` and `SortDescriptor`.

## Overview

`SiftFoundation` re-exports `Sift`, and adds Foundation backends for the same values:

```swift
let predicate = NSPredicate.build(for: Product.self) {
    \.price < 5
    HasPrefix(\.name, "cafe", options: [.caseInsensitive, .diacriticInsensitive])
}
// price < 5 AND name BEGINSWITH[cd] "cafe"

let descriptors = [NSSortDescriptor].build(for: Product.self) {
    Descending(\.price)
    Ascending(\.name, comparator: .localizedStandard)
}
```

### Requirements

The conversions use key-value coding, so:

- the root type must be an `NSObject` subclass, as Core Data's `NSManagedObject` is;
- every property in a keypath must be `@objc`.

Compared values must be of a type key-value coding can represent, which
``NSPredicateUsableValue`` lists: the scalar types, `String`, `Date`, `Data`, `UUID`, `URL`,
`NSObject` subclasses and their optionals. Other types, such as `Decimal` (use
`NSDecimalNumber`), fail to compile. An `@objc enum` works once you declare
`extension MyEnum: NSPredicateUsableValue {}`; its constants are compared by raw value.

Whether a property is `@objc` can't be expressed in a type. A stored `Int?`, `Double?` or
`Bool?` can't be `@objc`, but an optional scalar still works through optional chaining, as
in `\.parent?.rank`. Converting a keypath to a non-`@objc` property stops with a message
that names the keypath.

### Sorting

`SortDescriptor` works for keypaths to `Bool`, the integer types, `Double`, `Float`, `Date`
and `UUID`, and their optionals (see ``SortDescriptorUsableValue``), within the `@objc`
limits above. Sort strings with a comparator: `Ascending(\.name, comparator: .localizedStandard)`.
In-memory sorting with a comparator uses the same string comparison as Foundation.

### String matching

`Contains`, `HasPrefix` and `HasSuffix` are evaluated in memory with `NSString` matching, so
their results match `NSPredicate`'s `CONTAINS`, `BEGINSWITH` and `ENDSWITH`, including the
`[c]` and `[d]` options.

### Comparison semantics

When `SiftFoundation` is part of a program, in-memory evaluation, including `filter(by:)`
and `sorted(by:)` from `Sift`, compares these types the way Foundation does, so both
backends select and order the same values:

- **Strings**: `==`, `!=` and ``OneOf`` use `NSString.isEqual(to:)`, which doesn't apply
  Unicode normalization; `<`, `<=`, `>`, `>=` and keypath orders use
  `NSString.compare(_:)`. Swift's own `String` comparison would consider a decomposed
  "Cafe\u{301}" equal to "Café", and order "éclair" after "f".
- **Floating point** (`Double`, `Float`, `CGFloat`): comparisons follow
  `NSNumber.compare(_:)`, which orders NaN and considers it equal to itself. Swift's `<` and
  `==` are always false for NaN.

These come from ``SiftCustomComparable`` conformances. Without `SiftFoundation`, `Sift`
uses Swift's semantics.

## Topics

### Predicates

- ``NSPredicateConvertible``
- ``NSPredicateConvertibleValueOperator``
- ``NSComparisonPredicateValueOperator``
- ``NSPredicateUsableValue``
- ``NSPredicateConvertibleBinaryPredicateOperator``
- ``NSPredicateConvertibleUnaryOperator``
- ``StringMatchingOperator``

### Sort descriptors

- ``SortDescriptorsConvertible``
- ``SortDescriptorsConvertibleOperator``
- ``SortDescriptorUsableValue``
- ``SortDescriptorUsableOptionalWrapped``
- ``StringComparatorOrderOperator``
- ``OptionalStringComparatorOrderOperator``
