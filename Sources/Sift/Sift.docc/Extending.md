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

So the expression `\.name < 3` is a valid ``SiftPredicate`` whatever the types are. It can
only be *evaluated* when every node and operator in the tree has a conformance for the
backend in use.

## Adding an operator

1. Declare a marker type, for example `public enum LikeOperator<Value>: PredicateValueOperator {}`.
2. Add a function or operator that builds the node.
3. Conform the marker type to each backend's operator protocol.

If you skip a backend, expressions using the operator still compile, but that backend's
entry points, such as `filter(by:)` or `.predicate`, won't accept them.

## Adding a backend

Declare a protocol, for example `SQLConvertible`. Then conform each node conditionally on
its children, and each operator, to that protocol. Nothing in Sift itself has to change.
