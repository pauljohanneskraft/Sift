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

Swift-only types, such as `Int?` or a Swift `enum`, can't be represented in Objective-C,
so you can't use them in a converted predicate.

### Sorting

`SortDescriptor` works for keypaths to `Bool`, the integer types, `Double`, `Float`, `Date`
and `UUID`, and their optionals (see ``SortDescriptorUsableValue``). Sort strings with a
comparator: `Ascending(\.name, comparator: .localizedStandard)`.

### String matching

`Contains`, `HasPrefix` and `HasSuffix` are evaluated in memory with Foundation's string
comparison, so their results match `NSPredicate`'s `CONTAINS`, `BEGINSWITH` and `ENDSWITH`,
including the `[c]` and `[d]` options.

## Topics

### Predicates

- ``NSPredicateConvertible``
- ``NSPredicateConvertibleValueOperator``
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
