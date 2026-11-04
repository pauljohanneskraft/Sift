
// Ordering comparisons on optional values, such as `\.score < 3` where `score` is `Int?`.
// A `nil` on either side makes the comparison `false`; see `OptionalComparison`.
// Equality (`==`, `!=`) on optionals needs no extra overloads, because `Optional` is
// `Equatable` whenever its wrapped type is.

// MARK: Keypath and value

public func < <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

public func < <Root, Wrapped>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

public func <= <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

public func <= <Root, Wrapped>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

public func > <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

public func > <Root, Wrapped>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

public func >= <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: Wrapped
) -> KeyPathValuePredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: lhs, value: rhs)
}

public func >= <Root, Wrapped>(
    lhs: Wrapped,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathValuePredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(keyPath: rhs, value: lhs)
}

// MARK: Two keypaths

public func < <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<LessThanOperator<Wrapped>>> {
    .init(lhs, rhs)
}

public func <= <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<LessThanOrEqualOperator<Wrapped>>> {
    .init(lhs, rhs)
}

public func > <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<GreaterThanOperator<Wrapped>>> {
    .init(lhs, rhs)
}

public func >= <Root, Wrapped>(
    lhs: KeyPath<Root, Wrapped?>,
    rhs: KeyPath<Root, Wrapped?>
) -> KeyPathKeyPathPredicateValue<Root, OptionalComparison<GreaterThanOrEqualOperator<Wrapped>>> {
    .init(lhs, rhs)
}
