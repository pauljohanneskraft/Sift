
/// Marker for membership tests (`IN` in `NSPredicate`).
public enum InOperator {}

/// Matches when the value at a keypath equals one of a list of values.
///
/// Use it through ``OneOf``: `OneOf(\.category, ["fruit", "vegetable"])`.
public struct MembershipPredicateValue<Root, Value>: SiftPredicate {
    public typealias Operator = InOperator

    public let keyPath: KeyPath<Root, Value>
    public let values: [Value]

    public init(_ keyPath: KeyPath<Root, Value>, _ values: [Value]) {
        self.keyPath = keyPath
        self.values = values
    }
}

/// Matches when the value at the keypath is one of the given values (`IN` in `NSPredicate`).
public typealias OneOf<Root, Value> = MembershipPredicateValue<Root, Value>
