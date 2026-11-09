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
///
/// `Root` is a generic parameter rather than derived from `First.Root`, so the type checker
/// can push the root of an enclosing call, such as `filter(by:)`, down into each operand.
/// Every keypath literal in a long `&&` chain then resolves on its own, instead of the
/// solver trying every overload combination of the whole chain.
public struct BinaryPredicate<
    Root,
    First: SiftPredicate<Root>,
    Second: SiftPredicate<Root>,
    Operator
>: SiftPredicate {

    public let elements: (first: First, second: Second)

    public init(_ first: First, _ second: Second) {
        self.elements = (first, second)
    }

}

public typealias And<Root, First: SiftPredicate<Root>, Second: SiftPredicate<Root>> =
    BinaryPredicate<Root, First, Second, AndOperator>

public typealias Or<Root, First: SiftPredicate<Root>, Second: SiftPredicate<Root>> =
    BinaryPredicate<Root, First, Second, OrOperator>

public typealias Xor<Root, First: SiftPredicate<Root>, Second: SiftPredicate<Root>> =
    BinaryPredicate<Root, First, Second, XorOperator>

public typealias Nand<Root, First: SiftPredicate<Root>, Second: SiftPredicate<Root>> =
    BinaryPredicate<Root, First, Second, NandOperator>

public func && <Root, LHS: SiftPredicate<Root>, RHS: SiftPredicate<Root>>(
    lhs: LHS, rhs: RHS
) -> And<Root, LHS, RHS> {
    .init(lhs, rhs)
}

public func || <Root, LHS: SiftPredicate<Root>, RHS: SiftPredicate<Root>>(
    lhs: LHS, rhs: RHS
) -> Or<Root, LHS, RHS> {
    .init(lhs, rhs)
}
