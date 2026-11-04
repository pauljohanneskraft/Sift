# Getting Started

Filter and sort collections with predicates and orders.

## Predicates

Comparing a keypath with a value, or with another keypath of the same root, creates a
predicate:

```swift
items.filter(by: \.price < 5)
items.filter(by: \.price > \.discount)
items.filter(by: \.stock > 0 && !(\.category == "drink"))
```

Ordering comparisons also work on optional properties. A `nil` value never matches:

```swift
items.filter(by: \.rating >= 4)
```

``Xor`` and ``Nand`` have no operators. Construct them directly: `Xor(a, b)`.

For membership tests, use ``OneOf``: `OneOf(\.category, ["fruit", "vegetable"])`.

## Builders

`filterPredicate { }` joins its statements with AND. Inside it, ``AnyOf`` joins with OR and
``AllOf`` with AND, and `if`/`else` adds conditions at runtime:

```swift
items.filterPredicate {
    \.price < 5
    if !searchText.isEmpty {
        \.name == searchText
    }
}
```

An `if` whose condition is false contributes the group's identity value, `true` for AND and
`false` for OR, so it never changes the result.

## Orders

Wrap a keypath in ``Ascending`` or ``Descending``. Chain orders with
``Order/then(_:)``, or list them in ``OrderBuilder``, where a bare keypath means
ascending:

```swift
items.sorted(by: Descending(\.stock).then(Ascending(\.price)))

items.sortedOrder {
    Reverse {
        \.stock
    }
    \.name
}
```

An optional keypath sorts with `nil` first, as it does in Foundation.
