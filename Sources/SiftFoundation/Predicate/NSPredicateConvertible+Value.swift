
import Foundation

public protocol NSPredicateConvertibleValueOperator: PredicateValueOperator {

    static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate

    static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate

}

extension KeyPathKeyPathPredicateValue: NSPredicateConvertible where Root: NSObject, Operator: NSPredicateConvertibleValueOperator {
    public var predicate: NSPredicate {
        Operator.predicate(for: keyPaths.0, and: keyPaths.1)
    }
}

extension KeyPathValuePredicateValue: NSPredicateConvertible where Root: NSObject, Operator: NSPredicateConvertibleValueOperator {
    public var predicate: NSPredicate {
        Operator.predicate(for: keyPath, and: value)
    }
}

extension EqualOperator: NSPredicateConvertibleValueOperator where Value: Equatable {

    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .equalTo
        )
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .equalTo
        )
    }

}

extension NotEqualOperator: NSPredicateConvertibleValueOperator where Value: Equatable {

    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .notEqualTo
        )
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .notEqualTo
        )
    }


}

extension LessThanOperator: NSPredicateConvertibleValueOperator where Value: Comparable {

    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .lessThan
        )
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .lessThan
        )
    }

}

extension LessThanOrEqualOperator: NSPredicateConvertibleValueOperator where Value: Comparable {

    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .lessThanOrEqualTo
        )
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .lessThanOrEqualTo
        )
    }

}

extension GreaterThanOperator: NSPredicateConvertibleValueOperator where Value: Comparable {

    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .greaterThan
        )
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .greaterThan
        )
    }

}

extension GreaterThanOrEqualOperator: NSPredicateConvertibleValueOperator where Value: Comparable {

    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .greaterThanOrEqualTo
        )
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .greaterThanOrEqualTo
        )
    }

}
