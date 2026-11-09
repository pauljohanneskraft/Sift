
/// Marker for a constant predicate.
public enum BooleanOperator {}

/// A predicate that always evaluates to the same value.
public struct BooleanPredicate<Root>: SiftPredicate {
    public typealias Operator = BooleanOperator

    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}
