
// Ordering comparisons on optional values, such as `\.score < 3` where `score` is `Int?`.
// A `nil` on either side makes the comparison `false`; see `OptionalComparison`.
// Equality (`==`, `!=`) on optionals needs no extra overloads, because `Optional` is
// `Equatable` whenever its wrapped type is.
//
// Type-checking performance: these overloads double the candidates for every comparison in
// a `&&` chain. What keeps long chains fast is that `BinaryPredicate` and `UnaryPredicate`
// take `Root` as a generic parameter, so each keypath literal learns its root from the
// enclosing call and the wrong overloads fail immediately. In addition, the generic ordering
// overloads require `Value: Comparable`, so they never apply to an optional keypath, and
// these are `@_disfavoredOverload` as a tie-breaker.

// MARK: Keypath and value

@_disfavoredOverload
public func < <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func < <Root, Wrapped: Comparable>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

@_disfavoredOverload
public func <= <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func <= <Root, Wrapped: Comparable>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

@_disfavoredOverload
public func > <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func > <Root, Wrapped: Comparable>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

@_disfavoredOverload
public func >= <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func >= <Root, Wrapped: Comparable>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

// MARK: Two keypaths

@_disfavoredOverload
public func < <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(lhs, rhs)
}

@_disfavoredOverload
public func <= <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(lhs, rhs)
}

@_disfavoredOverload
public func > <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(lhs, rhs)
}

@_disfavoredOverload
public func >= <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(lhs, rhs)
}
