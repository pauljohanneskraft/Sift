import Foundation

/// A comparison operator that can be converted into an `NSPredicate`.
///
/// Implement both requirements for full control over the generated predicate, for example
/// to add options such as `[c]`. For a plain `NSComparisonPredicate`, conform to
/// ``NSComparisonPredicateValueOperator`` instead, which only needs the operator type.
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

/// A comparison operator that maps directly onto an `NSComparisonPredicate.Operator`, for
/// values that ``NSPredicateUsableValue`` can bridge.
public protocol NSComparisonPredicateValueOperator: NSPredicateConvertibleValueOperator
where Value: NSPredicateUsableValue {
    static var comparisonType: NSComparisonPredicate.Operator { get }
}

extension NSComparisonPredicateValueOperator {
    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Value>,
        and keyPath1: KeyPath<Root, Value>
    ) -> NSPredicate {
        comparison(keyPathExpression(keyPath0), comparisonType, keyPathExpression(keyPath1))
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Value>,
        and value: Value
    ) -> NSPredicate {
        comparison(keyPathExpression(keyPath), comparisonType, constantExpression(value))
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

// The value constraints mirror the Swift backend, plus `NSPredicateUsableValue`, so that a
// type key-value coding can't represent fails to compile.

extension EqualOperator: NSPredicateConvertibleValueOperator, NSComparisonPredicateValueOperator
where Value: Equatable & NSPredicateUsableValue {
    public static var comparisonType: NSComparisonPredicate.Operator { .equalTo }
}

extension NotEqualOperator: NSPredicateConvertibleValueOperator, NSComparisonPredicateValueOperator
where Value: Equatable & NSPredicateUsableValue {
    public static var comparisonType: NSComparisonPredicate.Operator { .notEqualTo }
}

extension LessThanOperator: NSPredicateConvertibleValueOperator, NSComparisonPredicateValueOperator
where Value: Comparable & NSPredicateUsableValue {
    public static var comparisonType: NSComparisonPredicate.Operator { .lessThan }
}

extension LessThanOrEqualOperator: NSPredicateConvertibleValueOperator, NSComparisonPredicateValueOperator
where Value: Comparable & NSPredicateUsableValue {
    public static var comparisonType: NSComparisonPredicate.Operator { .lessThanOrEqualTo }
}

extension GreaterThanOperator: NSPredicateConvertibleValueOperator, NSComparisonPredicateValueOperator
where Value: Comparable & NSPredicateUsableValue {
    public static var comparisonType: NSComparisonPredicate.Operator { .greaterThan }
}

extension GreaterThanOrEqualOperator: NSPredicateConvertibleValueOperator, NSComparisonPredicateValueOperator
where Value: Comparable & NSPredicateUsableValue {
    public static var comparisonType: NSComparisonPredicate.Operator { .greaterThanOrEqualTo }
}

// In memory, a `nil` on either side makes an optional comparison `false`. `NSPredicate`
// considers `nil <= nil` true when comparing two keypaths, so both sides are guarded
// explicitly there. The guards also keep the two backends in agreement under `NOT`.
extension OptionalComparison: NSPredicateConvertibleValueOperator
where Base: NSComparisonPredicateValueOperator {
    public static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, Base.Value?>,
        and keyPath1: KeyPath<Root, Base.Value?>
    ) -> NSPredicate {
        let lhs = keyPathExpression(keyPath0)
        let rhs = keyPathExpression(keyPath1)
        let null = NSExpression(forConstantValue: nil)
        return compoundPredicate(.and, [
            comparison(lhs, .notEqualTo, null),
            comparison(rhs, .notEqualTo, null),
            comparison(lhs, Base.comparisonType, rhs),
        ])
    }

    public static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, Base.Value?>,
        and value: Base.Value?
    ) -> NSPredicate {
        // A `nil` keypath value already compares as false against a non-`nil` constant.
        guard let value = value else {
            return NSPredicate(value: false)
        }
        return comparison(keyPathExpression(keyPath), Base.comparisonType, constantExpression(value))
    }
}
