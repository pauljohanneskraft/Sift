import Foundation

// String matching is evaluated here rather than in `Sift`, so in-memory matching uses the same
// Foundation string comparison as `NSPredicate`.
//
// Matching goes through `NSString`, not Swift's `String.range(of:)`. Swift only matches on
// `Character` boundaries, so it wouldn't find "\n" in "a\r\nb" or a single scalar inside an
// emoji sequence, while `NSPredicate` does.
private func nsStringMatches(_ value: String, _ pattern: String, _ options: String.CompareOptions) -> Bool {
    (value as NSString).range(of: pattern, options: options).location != NSNotFound
}

extension ContainsOperator: StringMatchingOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { .contains }

    public static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool {
        nsStringMatches(value, pattern, options)
    }
}

extension HasPrefixOperator: StringMatchingOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { .beginsWith }

    public static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool {
        nsStringMatches(value, pattern, options.union(.anchored))
    }
}

extension HasSuffixOperator: StringMatchingOperator {
    public static var comparisonType: NSComparisonPredicate.Operator { .endsWith }

    public static func matches(_ value: String, pattern: String, options: String.CompareOptions) -> Bool {
        nsStringMatches(value, pattern, options.union([.anchored, .backwards]))
    }
}

// Module-qualified names mark the conformance as intentional (SE-0364).
extension Sift.StringPredicateValue: Sift.SwiftEvaluablePredicate where Operator: StringMatchingOperator {
    public func evaluate(on root: Root) -> Bool {
        guard let value = root[keyPath: keyPath].siftStringValue else {
            return false
        }
        return Operator.matches(value, pattern: pattern, options: options.compareOptions)
    }
}
