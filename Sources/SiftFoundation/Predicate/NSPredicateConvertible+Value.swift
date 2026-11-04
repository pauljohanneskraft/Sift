import Foundation

/// A comparison operator that maps onto an `NSComparisonPredicate.Operator`.
public protocol NSPredicateConvertibleValueOperator: PredicateValueOperator {
    static var comparisonType: NSComparisonPredicate.Operator { get }
}

extension NSPredicateConvertibleValueOperator {
    static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: comparisonType
        )
    }

    static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: constantExpression(value),
            modifier: .direct,
            type: comparisonType
        )
    }
}

extension KeyPathKeyPathPredicateValue: NSPredicateConvertible
where Root: NSObject, Operator: NSPredicateConvertibleValueOperator {
    public var predicate: NSPredicate {
        Operator.predicate(for: keyPaths.0, and: keyPaths.1)
    }
}

extension KeyPathValuePredicateValue: NSPredicateConvertible
where Root: NSObject, Operator: NSPredicateConvertibleValueOperator {
    public var predicate: NSPredicate {
        Operator.predicate(for: keyPath, and: value)
    }
}

// The value constraints mirror the Swift backend, so both backends accept the same expressions.

extension EqualOperator: NSPredicateConvertibleValueOperator where Value: Equatable {
    public static var comparisonType: NSComparisonPredicate.Operator { .equalTo }
}

extension NotEqualOperator: NSPredicateConvertibleValueOperator where Value: Equatable {
    public static var comparisonType: NSComparisonPredicate.Operator { .notEqualTo }
}

extension LessThanOperator: NSPredicateConvertibleValueOperator where Value: Comparable {
    public static var comparisonType: NSComparisonPredicate.Operator { .lessThan }
}

extension LessThanOrEqualOperator: NSPredicateConvertibleValueOperator where Value: Comparable {
    public static var comparisonType: NSComparisonPredicate.Operator { .lessThanOrEqualTo }
}

extension GreaterThanOperator: NSPredicateConvertibleValueOperator where Value: Comparable {
    public static var comparisonType: NSComparisonPredicate.Operator { .greaterThan }
}

extension GreaterThanOrEqualOperator: NSPredicateConvertibleValueOperator where Value: Comparable {
    public static var comparisonType: NSComparisonPredicate.Operator { .greaterThanOrEqualTo }
}

extension OptionalComparison: NSPredicateConvertibleValueOperator
where Base: NSPredicateConvertibleValueOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { Base.comparisonType }
}
