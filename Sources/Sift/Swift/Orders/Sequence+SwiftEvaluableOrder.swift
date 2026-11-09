
extension Sequence {
    /// Returns the elements sorted by `order`.
    public func sorted<O: SwiftEvaluableOrder>(by order: O) -> [Element] where O.Root == Element {
        sorted { order.compare($0, $1) == .ascending }
    }

    /// Returns the elements sorted in ascending order of the value at `keyPath`.
    ///
    /// Disfavored, so that an app's own `sorted(by:)` keypath helper takes precedence
    /// instead of making the call ambiguous.
    @_disfavoredOverload
    public func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: Ascending(keyPath))
    }

    /// Returns the elements sorted by the order built in `order`. Later statements break
    /// ties left by earlier ones.
    public func sortedOrder<O: SwiftEvaluableOrder>(
        @OrderBuilder<Element> by order: () -> O
    ) -> [Element] where O.Root == Element {
        sorted(by: order())
    }
}
