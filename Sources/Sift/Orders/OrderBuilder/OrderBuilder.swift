
@resultBuilder
public struct OrderBuilder<Root> {

    public static func buildExpression<Value>(
        _ expression: KeyPath<Root, Value>
    ) -> Ascending<Root, KeyPath<Root, Value>> {
        Ascending(expression)
    }

    public static func buildExpression<O: Order<Root>>(_ component: O) -> O {
        component
    }

    public static func buildBlock<O: Order<Root>>(_ component: O) -> O {
        component
    }

    public static func buildPartialBlock<O: Order<Root>>(first: O) -> O {
        first
    }

    public static func buildPartialBlock<First: Order, Second: Order>(
        accumulated: First,
        next: Second
    ) -> ConcatenatedOrder<First, Second> {
        .init(first: accumulated, second: next)
    }

}
