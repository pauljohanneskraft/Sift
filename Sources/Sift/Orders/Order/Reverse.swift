
/// An order that inverts the direction of another order.
///
/// `Root` is a generic parameter, not derived from `O`, so that a `Reverse { … }` nested in
/// an ``OrderBuilder`` can infer it from the enclosing builder.
public struct Reverse<Root, O: Order<Root>>: Order {
    public let order: O

    public init(_ order: O) {
        self.order = order
    }

    /// Builds the reversed order with ``OrderBuilder``. The root type is inferred from an
    /// enclosing builder or call; pass `for:` when there is none.
    public init(
        for root: Root.Type = Root.self,
        @OrderBuilder<Root> _ order: () -> O
    ) {
        self.order = order()
    }
}

extension Reverse {
    // See `Ascending.init(_: KeyPath)`: a concrete keypath parameter lets `\.member` infer its root.
    @_disfavoredOverload
    public init<Value>(_ keyPath: KeyPath<Root, Value>) where O == KeyPath<Root, Value> {
        self.order = keyPath
    }
}

extension Reverse where O == Ascending<Root, KeyPath<Root, Root>> {
    /// Reverses the natural order of the values, for example `[1, 3, 2].sorted(by: Reverse())`.
    public init() {
        self.init(Ascending())
    }
}
