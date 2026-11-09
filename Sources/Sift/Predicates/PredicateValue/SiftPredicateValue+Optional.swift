// Ordering comparisons on optional values, such as `\.score < 3` where `score` is `Int?`.
// A `nil` on either side makes the comparison `false`; see `OptionalComparison`.
// Equality (`==`, `!=`) on optionals needs no extra overloads, because `Optional` is
// `Equatable` whenever its wrapped type is.
//
// Type-checking performance: every overload of `<` adds a candidate to every comparison in a
// `&&` chain, also when no optional is involved. Measured with Swift 6.0 and 6.2, these four
// keep a 7-term chain compiling, as on `main`, but four more fail it. So there are no
// optional overloads with the value on the left (`3 < \.score`, write `\.score > 3`) or with
// two optional keypaths. Build those explicitly:
//
//     KeyPathKeyPathPredicateValue<Root, OptionalComparison<LessThanOperator<Date>>>(\.start, \.end)
//
// The generic ordering overloads require `Value: Comparable`, so they never apply to an
// optional keypath, and these are `@_disfavoredOverload` as a tie-breaker. `BinaryPredicate`
// and `UnaryPredicate` take `Root` as a generic parameter, which lets newer compilers resolve
// each keypath literal locally.

// MARK: Keypath and value

@_disfavoredOverload
public func < <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func <= <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func > <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

@_disfavoredOverload
public func >= <Root, Wrapped: Comparable>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

