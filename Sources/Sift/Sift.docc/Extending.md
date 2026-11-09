# Extending Sift

Add operators and backends through conditional conformances.

## Overview

Sift separates the *representation* of a predicate or order from its *interpretation*.

- **Nodes** are inert, generic values, such as ``BinaryPredicate``,
  ``KeyPathValuePredicateValue``, ``Ascending`` and ``Reverse``.
- **Operators** are empty marker types, such as ``AndOperator`` and ``LessThanOperator``. A
  node's `Operator` generic parameter says what kind of node it is; it carries no behavior.
- **Backends** give the nodes meaning by conforming them conditionally to a protocol. In
  this module, ``SwiftEvaluablePredicate`` and ``SwiftEvaluableOrder`` evaluate in memory.
  `SiftFoundation` adds `NSPredicateConvertible` and `SortDescriptorsConvertible`.

For example, in-memory evaluation of a comparison is declared like this:

```swift
extension KeyPathValuePredicateValue: SwiftEvaluablePredicate
where Operator: SwiftEvaluablePredicateValueOperator { … }

extension LessThanOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable { … }
```

The DSL itself only checks what it needs to build the tree: both sides of a comparison
must have the same type, and the ordering operators `<`, `<=`, `>` and `>=` require a
`Comparable` value (or an optional of one). A tree can then only be *evaluated* when every
node and operator in it has a conformance for the backend in use.

## Adding an operator

1. Declare a marker type, for example `public enum LikeOperator<Value>: PredicateValueOperator {}`.
2. Add a function or operator that builds the node.
3. Conform the marker type to each backend's operator protocol.

If you skip a backend, expressions using the operator still compile, but that backend's
entry points, such as `filter(by:)` or `.predicate`, won't accept them.

## Custom orders and comparison semantics

A custom ``SwiftEvaluableOrder`` only needs ``SwiftEvaluableOrder/isLessThan(_:_:)``.
Implement ``SwiftEvaluableOrder/compare(_:_:)`` too when a three-way comparison is cheaper;
`.then` chains and arrays of orders use it.

To change how a value type compares in memory, conform it to ``SiftCustomComparable``.
`SiftFoundation` does this for `String` and the floating-point types, so that in-memory
results match Foundation's.

## Adding a backend

Declare a protocol, for example `SQLConvertible`. Then conform each node conditionally on
its children, and each operator, to that protocol. Nothing in Sift itself has to change.
