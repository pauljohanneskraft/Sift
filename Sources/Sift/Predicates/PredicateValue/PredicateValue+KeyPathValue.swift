
public struct KeyPathValuePredicateValue<
    Root,
    Operator: PredicateValueOperator
>: PredicateValue {
    public typealias Value = Operator.Value

    public let keyPath: KeyPath<Root, Value>
    public let value: Value

}

// MARK: Equality

public func == <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: Value
) -> KeyPathValuePredicateValue<Root, EqualOperator<Value>> {
    .init(keyPath: lhs, value: rhs)
}

public func == <Root, Value>(
    lhs: Value,
    rhs: KeyPath<Root, Value>
) -> KeyPathValuePredicateValue<Root, EqualOperator<Value>> {
    .init(keyPath: rhs, value: lhs)
}

public func != <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: Value
) -> KeyPathValuePredicateValue<Root, NotEqualOperator<Value>> {
    .init(keyPath: lhs, value: rhs)
}

public func != <Root, Value>(
    lhs: Value,
    rhs: KeyPath<Root, Value>
) -> KeyPathValuePredicateValue<Root, NotEqualOperator<Value>> {
    .init(keyPath: rhs, value: lhs)
}


// MARK: Order

public func < <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: Value
) -> KeyPathValuePredicateValue<Root, LessThanOperator<Value>> {
    .init(keyPath: lhs, value: rhs)
}

public func < <Root, Value>(
    lhs: Value,
    rhs: KeyPath<Root, Value>
) -> KeyPathValuePredicateValue<Root, GreaterThanOperator<Value>> {
    .init(keyPath: rhs, value: lhs)
}

public func <= <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: Value
) -> KeyPathValuePredicateValue<Root, LessThanOrEqualOperator<Value>> {
    .init(keyPath: lhs, value: rhs)
}

public func <= <Root, Value>(
    lhs: Value,
    rhs: KeyPath<Root, Value>
) -> KeyPathValuePredicateValue<Root, GreaterThanOrEqualOperator<Value>> {
    .init(keyPath: rhs, value: lhs)
}

public func > <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: Value
) -> KeyPathValuePredicateValue<Root, GreaterThanOperator<Value>> {
    .init(keyPath: lhs, value: rhs)
}

public func > <Root, Value>(
    lhs: Value,
    rhs: KeyPath<Root, Value>
) -> KeyPathValuePredicateValue<Root, LessThanOperator<Value>> {
    .init(keyPath: rhs, value: lhs)
}

public func >= <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: Value
) -> KeyPathValuePredicateValue<Root, GreaterThanOrEqualOperator<Value>> {
    .init(keyPath: lhs, value: rhs)
}

public func >= <Root, Value>(
    lhs: Value,
    rhs: KeyPath<Root, Value>
) -> KeyPathValuePredicateValue<Root, LessThanOrEqualOperator<Value>> {
    .init(keyPath: rhs, value: lhs)
}
