
/// Marker for membership tests (`IN` in `NSPredicate`).
public enum InOperator {}

/// Matches when the value at a keypath equals one of a list of values.
///
/// Use it through ``OneOf``: `OneOf(\.category, ["fruit", "vegetable"])`. For `Hashable`
/// values, in-memory evaluation looks values up in a `Set` instead of scanning the list.
public struct MembershipPredicateValue<Root, Value>: SiftPredicate {
    public typealias Operator = InOperator

    public let keyPath: KeyPath<Root, Value>
    public let values: [Value]

    /// A `Set` lookup, when `Value` is `Hashable` and compared with its own semantics.
    let hashedContains: ((Value) -> Bool)?

    public init(_ keyPath: KeyPath<Root, Value>, _ values: [Value]) {
        self.keyPath = keyPath
        self.values = values
        self.hashedContains = nil
    }
}

extension MembershipPredicateValue where Value: Hashable {
    public init(_ keyPath: KeyPath<Root, Value>, _ values: [Value]) {
        self.keyPath = keyPath
        self.values = values
        // A `Set` uses `Hashable` equality, which isn't the custom equality of a
        // `SiftCustomComparable` type, so those keep the linear scan.
        if SiftComparison.usesCustomSemantics(Value.self) {
            self.hashedContains = nil
        } else {
            let set = Set(values)
            self.hashedContains = { set.contains($0) }
        }
    }
}

/// Matches when the value at the keypath is one of the given values (`IN` in `NSPredicate`).
public typealias OneOf<Root, Value> = MembershipPredicateValue<Root, Value>
