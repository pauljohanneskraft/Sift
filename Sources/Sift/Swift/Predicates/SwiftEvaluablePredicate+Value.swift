
public protocol SwiftEvaluablePredicateValueOperator: PredicateValueOperator {
    static func compare(_ first: Value, with second: Value) -> Bool
}

extension KeyPathKeyPathPredicateValue: SwiftEvaluablePredicate where Operator: SwiftEvaluablePredicateValueOperator {
    public func evaluate(on root: Root) -> Bool {
        Operator.compare(root[keyPath: keyPaths.0], with: root[keyPath: keyPaths.1])
    }
}

extension KeyPathValuePredicateValue: SwiftEvaluablePredicate where Operator: SwiftEvaluablePredicateValueOperator {
    public func evaluate(on root: Root) -> Bool {
        Operator.compare(root[keyPath: keyPath], with: value)
    }
}

extension EqualOperator: SwiftEvaluablePredicateValueOperator where Value: Equatable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        first == second
    }
}

extension NotEqualOperator: SwiftEvaluablePredicateValueOperator where Value: Equatable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        first != second
    }
}

extension LessThanOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        first < second
    }
}

extension LessThanOrEqualOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        first <= second
    }
}

extension GreaterThanOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        first > second
    }
}

extension GreaterThanOrEqualOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        first >= second
    }
}
