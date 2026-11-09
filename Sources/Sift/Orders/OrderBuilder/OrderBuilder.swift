
/// A result builder that concatenates orders. A bare keypath means ``Ascending``, and each
/// statement breaks ties left by the statements before it.
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

    // An array's `Root` is derived from its elements, and the type checker joins the element
    // types of a multi-element literal before it can pass the builder's root into them. These
    // overloads give the literal a concrete element type, so that
    // `[Ascending(\.price), Ascending(\.discount)]` and `[\.price, \.discount]` infer their root.

    public static func buildExpression<O: Order<Root>>(_ orders: [O]) -> [O] {
        orders
    }

    public static func buildExpression<Operator: OrderOperator<Root>>(
        _ orders: [Ascending<Root, Operator>]
    ) -> [Ascending<Root, Operator>] {
        orders
    }

    public static func buildExpression<Operator: OrderOperator<Root>>(
        _ orders: [Descending<Root, Operator>]
    ) -> [Descending<Root, Operator>] {
        orders
    }

    public static func buildExpression<O: Order<Root>>(_ orders: [Reverse<Root, O>]) -> [Reverse<Root, O>] {
        orders
    }

    // With a generic `Operator`, the type checker can't infer the root of several keypath
    // literals in one array, so keypath operators get concrete overloads.

    public static func buildExpression<Value>(
        _ orders: [Ascending<Root, KeyPath<Root, Value>>]
    ) -> [Ascending<Root, KeyPath<Root, Value>>] {
        orders
    }

    public static func buildExpression<Value>(
        _ orders: [Descending<Root, KeyPath<Root, Value>>]
    ) -> [Descending<Root, KeyPath<Root, Value>>] {
        orders
    }

    public static func buildExpression<Value>(
        _ orders: [Reverse<Root, KeyPath<Root, Value>>]
    ) -> [Reverse<Root, KeyPath<Root, Value>>] {
        orders
    }

    public static func buildExpression<Value>(
        _ keyPaths: [KeyPath<Root, Value>]
    ) -> [Ascending<Root, KeyPath<Root, Value>>] {
        keyPaths.map(Ascending.init)
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
