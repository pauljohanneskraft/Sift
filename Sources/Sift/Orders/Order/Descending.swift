
/// Sorts by `Operator` in reverse (descending) order.
///
/// `Operator` is usually a keypath, as in `Descending(\.price)`. `SiftFoundation` adds a
/// string-comparator variant: `Descending(\.name, comparator: .localizedStandard)`.
public struct Descending<Root, Operator: OrderOperator<Root>>: Order {
    public let `operator`: Operator

    // Disfavored for optional keypaths; see `Ascending.init(_:)`.
    @_disfavoredOverload
    public init(_ op: Operator) {
        self.operator = op
    }
}

extension Descending {
    // A dedicated keypath initializer gives a `\.member` literal a concrete contextual type.
    // Through `init(_: Operator)` alone, the compiler cannot infer the keypath's root.
    // Disfavored so that the optional-keypath overload (see `OptionalKeyPathOrder`) wins for `Wrapped?` values.
    @_disfavoredOverload
    public init<Value>(_ keyPath: KeyPath<Root, Value>) where Operator == KeyPath<Root, Value> {
        self.operator = keyPath
    }
}

extension Descending where Operator == KeyPath<Root, Root> {
    /// Orders values by themselves, for example `[3, 1, 2].sorted(by: Descending())`.
    public init() {
        self.init(\Root.self)
    }
}
