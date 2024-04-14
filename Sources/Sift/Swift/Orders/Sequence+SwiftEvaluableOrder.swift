
extension Sequence {
    public func sorted<O: SwiftEvaluableOrder>(by order: O) -> [Element] where O.Root == Element {
        sorted(by: order.isLessThan)
    }

    public func sortedOrder<O: SwiftEvaluableOrder>(@OrderBuilder<Element> by order: () -> O) -> [Element] where O.Root == Element {
        sorted(by: order().isLessThan)
    }
}
