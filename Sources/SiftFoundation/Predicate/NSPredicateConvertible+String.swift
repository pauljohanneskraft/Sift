import Foundation

/// A string-matching operator, evaluated both in memory and as an `NSPredicate`.
public protocol StringMatchingOperator {
    static var comparisonType: NSComparisonPredicate.Operator { get }
    static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool
}

extension StringMatchOptions {
    /// Each Sift option with its `String.CompareOptions` and `NSComparisonPredicate.Options`
    /// equivalents, so the two mappings can't drift apart.
    private static let mapping: [(StringMatchOptions, String.CompareOptions, NSComparisonPredicate.Options)] = [
        (.caseInsensitive, .caseInsensitive, .caseInsensitive),
        (.diacriticInsensitive, .diacriticInsensitive, .diacriticInsensitive),
    ]

    var compareOptions: String.CompareOptions {
        Self.mapping.reduce(into: []) { result, entry in
            if contains(entry.0) { result.insert(entry.1) }
        }
    }

    var comparisonPredicateOptions: NSComparisonPredicate.Options {
        Self.mapping.reduce(into: []) { result, entry in
            if contains(entry.0) { result.insert(entry.2) }
        }
    }
}

extension StringPredicateValue: NSPredicateConvertible where Root: NSObject, Operator: StringMatchingOperator {
    public var predicate: NSPredicate {
        comparison(
            keyPathExpression(keyPath),
            Operator.comparisonType,
            NSExpression(forConstantValue: pattern),
            options: options.comparisonPredicateOptions
        )
    }
}
