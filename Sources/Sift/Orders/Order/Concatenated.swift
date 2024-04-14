
extension Order {
    public func then<Second: Order>(_ second: Second) -> ConcatenatedOrder<Self, Second> {
        .init(first: self, second: second)
    }
}

public struct ConcatenatedOrder<First: Order, Second: Order>: Order where First.Root == Second.Root {
    public typealias Root = First.Root
    public let first: First
    public let second: Second

    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }
}
