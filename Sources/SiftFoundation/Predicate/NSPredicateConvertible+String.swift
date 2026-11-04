import Foundation

/// A string-matching operator, evaluated both in memory and as an `NSPredicate`.
public protocol StringMatchingOperator {
    static var comparisonType: NSComparisonPredicate.Operator { get }
    static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool
}

extension ContainsOperator: StringMatchingOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { .contains }

    public static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool {
        value.range(of: pattern, options: options) != nil
    }
}

extension HasPrefixOperator: StringMatchingOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { .beginsWith }

    public static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool {
        value.range(of: pattern, options: options.union(.anchored)) != nil
    }
}

extension HasSuffixOperator: StringMatchingOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { .endsWith }

    public static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool {
        value.range(of: pattern, options: options.union([.anchored, .backwards])) != nil
    }
}

extension StringMatchOptions {
    var compareOptions: String.CompareOptions {
        var result: String.CompareOptions = []
        if contains(.caseInsensitive) { result.insert(.caseInsensitive) }
        if contains(.diacriticInsensitive) { result.insert(.diacriticInsensitive) }
        return result
    }

    var comparisonPredicateOptions: NSComparisonPredicate.Options {
        var result: NSComparisonPredicate.Options = []
        if contains(.caseInsensitive) { result.insert(.caseInsensitive) }
        if contains(.diacriticInsensitive) { result.insert(.diacriticInsensitive) }
        return result
    }
}

// Evaluated here rather than in `Sift`, so in-memory matching uses the same Foundation string
// comparison as `NSPredicate`. Module-qualified names mark the conformance as intentional (SE-0364).
extension Sift.StringPredicateValue: Sift.SwiftEvaluablePredicate where Operator: StringMatchingOperator {
    public func evaluate(on root: Root) -> Bool {
        guard let value = root[keyPath: keyPath].siftStringValue else {
            return false
        }
        return Operator.matches(value, pattern: pattern, options: options.compareOptions)
    }
}

extension StringPredicateValue: NSPredicateConvertible where Root: NSObject, Operator: StringMatchingOperator {
    public var predicate: NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: pattern),
            modifier: .direct,
            type: Operator.comparisonType,
            options: options.comparisonPredicateOptions
        )
    }
}

extension MembershipPredicateValue: NSPredicateConvertible where Root: NSObject, Value: Equatable {
    public var predicate: NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: values),
            modifier: .direct,
            type: .in
        )
    }
}
