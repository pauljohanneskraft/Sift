
public struct KeyPathKeyPathPredicateValue<
    Root,
    Operator: PredicateValueOperator
>: PredicateValue {
    public typealias Value = Operator.Value

    public let keyPaths: (
        KeyPath<Root, Value>,
        KeyPath<Root, Value>
    )

}

// MARK: Equality

public func == <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, EqualOperator<Value>> {
    .init(keyPaths: (lhs, rhs))
}

public func != <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, NotEqualOperator<Value>> {
    .init(keyPaths: (lhs, rhs))
}

// MARK: Order

public func < <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, LessThanOperator<Value>> {
    .init(keyPaths: (lhs, rhs))
}

public func <= <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, LessThanOrEqualOperator<Value>> {
    .init(keyPaths: (lhs, rhs))
}

public func > <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, GreaterThanOperator<Value>> {
    .init(keyPaths: (lhs, rhs))
}

public func >= <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, GreaterThanOrEqualOperator<Value>> {
    .init(keyPaths: (lhs, rhs))
}
