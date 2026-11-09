
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

// The comparisons go through `SiftComparison`, so a `SiftCustomComparable` value type, such
// as `String` with `SiftFoundation`, is compared with its custom semantics.

extension EqualOperator: SwiftEvaluablePredicateValueOperator where Value: Equatable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        SiftComparison.isEqual(first, second)
    }
}

extension NotEqualOperator: SwiftEvaluablePredicateValueOperator where Value: Equatable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        !SiftComparison.isEqual(first, second)
    }
}

extension LessThanOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        SiftComparison.compare(first, second) == .ascending
    }
}

extension LessThanOrEqualOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        SiftComparison.compare(first, second) != .descending
    }
}

extension GreaterThanOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        SiftComparison.compare(first, second) == .descending
    }
}

extension GreaterThanOrEqualOperator: SwiftEvaluablePredicateValueOperator where Value: Comparable {
    public static func compare(_ first: Value, with second: Value) -> Bool {
        SiftComparison.compare(first, second) != .ascending
    }
}

extension OptionalComparison: SwiftEvaluablePredicateValueOperator
where Base: SwiftEvaluablePredicateValueOperator {
    public static func compare(_ first: Base.Value?, with second: Base.Value?) -> Bool {
        guard let first = first, let second = second else {
            return false
        }
        return Base.compare(first, with: second)
    }
}
