
/// Marker for a logical AND of two predicates.
public enum AndOperator {}
/// Marker for a logical OR of two predicates.
public enum OrOperator {}
/// Marker for a logical exclusive OR of two predicates.
public enum XorOperator {}
/// Marker for a logical NAND (not both) of two predicates.
public enum NandOperator {}

/// A predicate that combines two predicates over the same root with a binary operator.
///
/// Use it through the ``And``, ``Or``, ``Xor`` and ``Nand`` typealiases, for example
/// `Xor(\.isAdmin == true, \.isGuest == true)`, or through the `&&` and `||` operators.
public struct BinaryPredicate<
    First: SiftPredicate,
    Second: SiftPredicate,
    Operator
>: SiftPredicate where First.Root == Second.Root {

    public typealias Root = First.Root

    public let elements: (first: First, second: Second)

    public init(_ first: First, _ second: Second) {
        self.elements = (first, second)
    }

}

public typealias And<First: SiftPredicate, Second: SiftPredicate> =
    BinaryPredicate<First, Second, AndOperator> where First.Root == Second.Root

public typealias Or<First: SiftPredicate, Second: SiftPredicate> =
    BinaryPredicate<First, Second, OrOperator> where First.Root == Second.Root

public typealias Xor<First: SiftPredicate, Second: SiftPredicate> =
    BinaryPredicate<First, Second, XorOperator> where First.Root == Second.Root

public typealias Nand<First: SiftPredicate, Second: SiftPredicate> =
    BinaryPredicate<First, Second, NandOperator> where First.Root == Second.Root

public func && <LHS: SiftPredicate, RHS: SiftPredicate>(
    lhs: LHS, rhs: RHS
) -> And<LHS, RHS> {
    .init(lhs, rhs)
}

public func || <LHS: SiftPredicate, RHS: SiftPredicate>(
    lhs: LHS, rhs: RHS
) -> Or<LHS, RHS> {
    .init(lhs, rhs)
}
