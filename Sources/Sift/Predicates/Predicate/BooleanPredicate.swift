
public enum BooleanOperator {}

public struct BooleanPredicate<Root>: Predicate {
    public typealias Operator = BooleanOperator

    public let value: Bool

}
