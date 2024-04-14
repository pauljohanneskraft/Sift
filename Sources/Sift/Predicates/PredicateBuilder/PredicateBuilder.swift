
@resultBuilder
public enum PredicateBuilder<Root> {

    public static func buildExpression(_ expression: Bool) -> BooleanPredicate<Root> {
        .init(value: expression)
    }

    public static func buildExpression<P: Predicate<Root>>(_ component: P) -> P {
        component
    }

    public static func buildBlock() -> BooleanPredicate<Root> {
        .init(value: true)
    }

    public static func buildBlock<P: Predicate<Root>>(_ component: P) -> P {
        component
    }

    public static func buildPartialBlock<P: Predicate<Root>>(first: P) -> P {
        first
    }

    public static func buildPartialBlock<A: Predicate<Root>, B: Predicate<Root>, Operator>(
        accumulated: A,
        next: B
    ) -> BinaryPredicate<A, B, Operator> {
        .init(elements: (accumulated, next))
    }

}
