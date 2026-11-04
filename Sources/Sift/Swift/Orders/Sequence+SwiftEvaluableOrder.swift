
extension Sequence {
    /// Returns the elements sorted by `order`.
    public func sorted<O: SwiftEvaluableOrder>(by order: O) -> [Element] where O.Root == Element {
        sorted(by: order.isLessThan)
    }

    /// Returns the elements sorted in ascending order of the value at `keyPath`.
    public func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: keyPath.isLessThan)
    }

    /// Returns the elements sorted by the order built in `order`. Later statements break
    /// ties left by earlier ones.
    public func sortedOrder<O: SwiftEvaluableOrder>(
        @OrderBuilder<Element> by order: () -> O
    ) -> [Element] where O.Root == Element {
        sorted(by: order().isLessThan)
    }
}
