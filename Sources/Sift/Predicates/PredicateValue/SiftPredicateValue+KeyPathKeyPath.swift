
/// Compares the values at two keypaths of the same root.
public struct KeyPathKeyPathPredicateValue<
    Root,
    Operator: PredicateValueOperator
>: SiftPredicate {
    public typealias Value = Operator.Value

    public let keyPaths: (KeyPath<Root, Value>, KeyPath<Root, Value>)

    public init(_ lhs: KeyPath<Root, Value>, _ rhs: KeyPath<Root, Value>) {
        self.keyPaths = (lhs, rhs)
    }
}

// MARK: Equality

public func == <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, EqualOperator<Value>> {
    .init(lhs, rhs)
}

public func != <Root, Value>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, NotEqualOperator<Value>> {
    .init(lhs, rhs)
}

// MARK: Order

public func < <Root, Value: Comparable>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, LessThanOperator<Value>> {
    .init(lhs, rhs)
}

public func <= <Root, Value: Comparable>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, LessThanOrEqualOperator<Value>> {
    .init(lhs, rhs)
}

public func > <Root, Value: Comparable>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, GreaterThanOperator<Value>> {
    .init(lhs, rhs)
}

public func >= <Root, Value: Comparable>(
    lhs: KeyPath<Root, Value>,
    rhs: KeyPath<Root, Value>
) -> KeyPathKeyPathPredicateValue<Root, GreaterThanOrEqualOperator<Value>> {
    .init(lhs, rhs)
}
