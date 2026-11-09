
/// Sorts by `Operator` in its natural (ascending) order.
///
/// `Operator` is usually a keypath, as in `Ascending(\.price)`. `SiftFoundation` adds a
/// string-comparator variant: `Ascending(\.name, comparator: .localizedStandard)`.
public struct Ascending<Root, Operator: OrderOperator<Root>>: Order {
    public let `operator`: Operator

    // Disfavored so that `let order = Ascending(\Item.rating)` with an optional `rating`
    // picks the `OptionalKeyPathOrder` overload instead of using the keypath itself as
    // `Operator`, which can't be sorted in memory.
    @_disfavoredOverload
    public init(_ op: Operator) {
        self.operator = op
    }
}

extension Ascending {
    // A dedicated keypath initializer gives a `\.member` literal a concrete contextual type.
    // Through `init(_: Operator)` alone, the compiler cannot infer the keypath's root.
    // Disfavored so that the optional-keypath overload (see `OptionalKeyPathOrder`) wins for `Wrapped?` values.
    @_disfavoredOverload
    public init<Value>(_ keyPath: KeyPath<Root, Value>) where Operator == KeyPath<Root, Value> {
        self.operator = keyPath
    }
}

extension Ascending where Operator == KeyPath<Root, Root> {
    /// Orders values by themselves, for example `[3, 1, 2].sorted(by: Ascending())`.
    public init() {
        self.init(\Root.self)
    }
}
