
extension Order {
    /// Returns an order that sorts by `self`, and by `second` when `self` considers two values equal.
    public func then<Second: Order>(_ second: Second) -> ConcatenatedOrder<Self, Second> {
        .init(first: self, second: second)
    }
}

/// Two orders applied in sequence: `second` only breaks ties left by `first`.
public struct ConcatenatedOrder<First: Order, Second: Order>: Order where First.Root == Second.Root {
    public typealias Root = First.Root
    public let first: First
    public let second: Second

    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }
}
