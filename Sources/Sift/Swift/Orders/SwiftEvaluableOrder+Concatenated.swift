
extension ConcatenatedOrder: SwiftEvaluableOrder where First: SwiftEvaluableOrder, Second: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        compare(lhs, rhs) == .ascending
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        let result = first.compare(lhs, rhs)
        return result == .same ? second.compare(lhs, rhs) : result
    }
}
