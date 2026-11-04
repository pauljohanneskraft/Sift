
/// Orders by an optional keypath value. `nil` sorts before every non-`nil` value, as it
/// does in Foundation's `SortDescriptor` and `NSSortDescriptor`.
///
/// You rarely name this type. `Ascending(\.rating)`, `Descending(\.rating)`,
/// `Reverse(\.rating)`, a bare `\.rating` in an ``OrderBuilder``, and
/// `sorted(by: \.rating)` all create it when `rating` is optional.
public struct OptionalKeyPathOrder<Root, Wrapped>: Order, OrderOperator {
    public let keyPath: KeyPath<Root, Wrapped?>

    public init(_ keyPath: KeyPath<Root, Wrapped?>) {
        self.keyPath = keyPath
    }
}

extension Ascending {
    public init<Wrapped>(_ keyPath: KeyPath<Root, Wrapped?>) where Operator == OptionalKeyPathOrder<Root, Wrapped> {
        self.init(OptionalKeyPathOrder(keyPath))
    }
}

extension Descending {
    public init<Wrapped>(_ keyPath: KeyPath<Root, Wrapped?>) where Operator == OptionalKeyPathOrder<Root, Wrapped> {
        self.init(OptionalKeyPathOrder(keyPath))
    }
}

extension Reverse {
    public init<Wrapped>(_ keyPath: KeyPath<Root, Wrapped?>)
    where O == Ascending<Root, OptionalKeyPathOrder<Root, Wrapped>> {
        self.init(Ascending(keyPath))
    }
}

extension OrderBuilder {
    public static func buildExpression<Wrapped>(
        _ expression: KeyPath<Root, Wrapped?>
    ) -> Ascending<Root, OptionalKeyPathOrder<Root, Wrapped>> {
        Ascending(expression)
    }
}
