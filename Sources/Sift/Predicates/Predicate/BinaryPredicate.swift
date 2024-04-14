
public enum AndOperator {}
public enum OrOperator {}
public enum XorOperator {}
public enum NandOperator {}

public struct BinaryPredicate<
    First: Predicate,
    Second: Predicate,
    Operator
>: Predicate where First.Root == Second.Root {

    public typealias Root = First.Root

    public let elements: (first: First, second: Second)

}

extension BinaryPredicate {

    public init(@PredicateBuilder<Self> _ build: () -> Self) {
        self = build()
    }

}


public typealias And<First: Predicate, Second: Predicate> =
    BinaryPredicate<First, Second, AndOperator> where First.Root == Second.Root

public typealias Or<First: Predicate, Second: Predicate> =
    BinaryPredicate<First, Second, OrOperator> where First.Root == Second.Root

public typealias Xor<First: Predicate, Second: Predicate> =
    BinaryPredicate<First, Second, XorOperator> where First.Root == Second.Root

public typealias Nand<First: Predicate, Second: Predicate> =
    BinaryPredicate<First, Second, NandOperator> where First.Root == Second.Root

public func && <LHS: Predicate, RHS: Predicate>(
    lhs: LHS, rhs: RHS
) -> And<LHS, RHS> {
    .init(elements: (lhs, rhs))
}

public func || <LHS: Predicate, RHS: Predicate>(
    lhs: LHS, rhs: RHS
) -> Or<LHS, RHS> {
    .init(elements: (lhs, rhs))
}
