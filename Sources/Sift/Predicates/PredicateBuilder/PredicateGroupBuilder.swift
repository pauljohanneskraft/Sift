
/// A result builder that joins its statements with `Combinator` (AND or OR).
///
/// - A `Bool` statement becomes a constant ``BooleanPredicate``.
/// - An empty block evaluates to the combinator's identity: `true` for AND, `false` for OR.
/// - An `if` without `else` whose condition is false also contributes the identity, so it
///   doesn't affect the result.
@resultBuilder
public enum PredicateGroupBuilder<Root, Combinator: PredicateGroupCombinator> {

    // Disfavored: otherwise `\Item.price == \Item.discount` (explicit roots or keypath
    // variables) resolves to the standard library's `AnyKeyPath ==`, which returns `Bool`,
    // and the comparison silently becomes a constant.
    @_disfavoredOverload
    public static func buildExpression(_ expression: Bool) -> BooleanPredicate<Root> {
        .init(expression)
    }

    public static func buildExpression<P: SiftPredicate<Root>>(_ component: P) -> P {
        component
    }

    public static func buildBlock() -> BooleanPredicate<Root> {
        .init(Combinator.identity)
    }

    public static func buildPartialBlock<P: SiftPredicate<Root>>(first: P) -> P {
        first
    }

    public static func buildPartialBlock<A: SiftPredicate<Root>, B: SiftPredicate<Root>>(
        accumulated: A,
        next: B
    ) -> BinaryPredicate<Root, A, B, Combinator> {
        .init(accumulated, next)
    }

    public static func buildOptional<P: SiftPredicate<Root>>(
        _ component: P?
    ) -> EitherPredicate<P, BooleanPredicate<Root>> {
        component.map { .first($0) } ?? .second(.init(Combinator.identity))
    }

    public static func buildEither<F: SiftPredicate<Root>, S: SiftPredicate<Root>>(
        first component: F
    ) -> EitherPredicate<F, S> {
        .first(component)
    }

    public static func buildEither<F: SiftPredicate<Root>, S: SiftPredicate<Root>>(
        second component: S
    ) -> EitherPredicate<F, S> {
        .second(component)
    }

}
