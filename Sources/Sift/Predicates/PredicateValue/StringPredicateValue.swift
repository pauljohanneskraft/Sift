
/// Options for string-matching predicates. They correspond to `NSPredicate`'s `[c]` and `[d]` flags.
public struct StringMatchOptions: OptionSet, Hashable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Ignore case, as `[c]` does in `NSPredicate`.
    public static let caseInsensitive = StringMatchOptions(rawValue: 1 << 0)
    /// Ignore diacritics, as `[d]` does in `NSPredicate`.
    public static let diacriticInsensitive = StringMatchOptions(rawValue: 1 << 1)
}

/// A value a string-matching predicate can read: `String`, or `String?`, where `nil` never matches.
public protocol SiftStringValue {
    var siftStringValue: String? { get }
}

extension String: SiftStringValue {
    public var siftStringValue: String? { self }
}

extension Optional: SiftStringValue where Wrapped == String {
    public var siftStringValue: String? { self }
}

/// Marker for substring matching.
public enum ContainsOperator {}
/// Marker for prefix matching.
public enum HasPrefixOperator {}
/// Marker for suffix matching.
public enum HasSuffixOperator {}

/// Matches the string at a keypath against a pattern.
///
/// Use it through ``Contains``, ``HasPrefix`` or ``HasSuffix``:
///
/// ```swift
/// AnyOf {
///     Contains(\.name, "an")
///     HasPrefix(\.name, "cafe", options: [.caseInsensitive, .diacriticInsensitive])
/// }
/// ```
///
/// When the values being filtered are strings themselves, leave out the keypath:
/// `["apple", "kiwi"].filter(by: Contains("a"))`.
///
/// Evaluating it in memory requires `SiftFoundation`, which matches strings the same way
/// `NSPredicate` does.
public struct StringPredicateValue<Root, Value: SiftStringValue, Operator>: SiftPredicate {
    public let keyPath: KeyPath<Root, Value>
    public let pattern: String
    public let options: StringMatchOptions

    public init(_ keyPath: KeyPath<Root, Value>, _ pattern: String, options: StringMatchOptions = []) {
        self.keyPath = keyPath
        self.pattern = pattern
        self.options = options
    }
}

extension StringPredicateValue where Value == Root {
    /// Matches the value itself, for filtering a collection of strings.
    public init(_ pattern: String, options: StringMatchOptions = []) {
        self.init(\Root.self, pattern, options: options)
    }
}

/// Matches when the string contains the pattern (`CONTAINS` in `NSPredicate`).
public typealias Contains<Root, Value: SiftStringValue> = StringPredicateValue<Root, Value, ContainsOperator>

/// Matches when the string starts with the pattern (`BEGINSWITH` in `NSPredicate`).
public typealias HasPrefix<Root, Value: SiftStringValue> = StringPredicateValue<Root, Value, HasPrefixOperator>

/// Matches when the string ends with the pattern (`ENDSWITH` in `NSPredicate`).
public typealias HasSuffix<Root, Value: SiftStringValue> = StringPredicateValue<Root, Value, HasSuffixOperator>
