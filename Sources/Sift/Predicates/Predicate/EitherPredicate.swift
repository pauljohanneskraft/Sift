
/// Marker for ``EitherPredicate``.
public enum EitherOperator {}

/// A predicate that is one of two alternatives, chosen when the predicate is built.
///
/// The predicate builders produce it for `if`/`else` statements.
public enum EitherPredicate<First: SiftPredicate, Second: SiftPredicate>: SiftPredicate
where First.Root == Second.Root {
    public typealias Root = First.Root
    public typealias Operator = EitherOperator

    case first(First)
    case second(Second)
}
