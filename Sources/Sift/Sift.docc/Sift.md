# ``Sift``

Build predicates and sort orders from KeyPaths and result builders.

## Overview

Sift turns filtering and sorting logic into plain Swift values:

```swift
let affordable = items.filterPredicate {
    \.price < 5
    AnyOf {
        \.category == "fruit"
        \.stock > 10
    }
}

let sorted = items.sortedOrder {
    Descending(\.rating)
    \.price
}
```

The same values can be evaluated in memory, or converted to `NSPredicate` and sort
descriptors with the `SiftFoundation` module.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:Extending>

### Predicates

- ``SiftPredicate``
- ``SwiftEvaluablePredicate``
- ``BinaryPredicate``
- ``And``
- ``Or``
- ``Xor``
- ``Nand``
- ``UnaryPredicate``
- ``Not``
- ``BooleanPredicate``
- ``EitherPredicate``

### Comparisons

- ``SiftPredicateValue``
- ``KeyPathValuePredicateValue``
- ``KeyPathKeyPathPredicateValue``
- ``PredicateValueOperator``
- ``OptionalComparison``
- ``MembershipPredicateValue``
- ``OneOf``

### Strings

- ``StringPredicateValue``
- ``StringMatchOptions``
- ``SiftStringValue``
- ``Contains``
- ``HasPrefix``
- ``HasSuffix``

### Predicate builders

- ``AllOf``
- ``AnyOf``
- ``PredicateGroup``
- ``PredicateGroupBuilder``
- ``PredicateGroupCombinator``

### Orders

- ``Order``
- ``OrderOperator``
- ``SwiftEvaluableOrder``
- ``Ascending``
- ``Descending``
- ``Reverse``
- ``ConcatenatedOrder``
- ``OptionalKeyPathOrder``
- ``OrderBuilder``
