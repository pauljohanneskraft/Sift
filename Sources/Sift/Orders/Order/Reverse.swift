
public struct Reverse<O: Order>: Order {
    public typealias Root = O.Root

    public let order: O

    public init(_ order: O) {
        self.order = order
    }

    public init(@OrderBuilder<O.Root> order: () -> O) {
        self.order = order()
    }
}

extension Reverse {
    public init<Root>() where O == Ascending<Root, KeyPath<Root, Root>> {
        self.init(Ascending())
    }
}
