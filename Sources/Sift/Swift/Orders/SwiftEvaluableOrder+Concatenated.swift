
extension ConcatenatedOrder: SwiftEvaluableOrder where First: SwiftEvaluableOrder, Second: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        if first.isLessThan(lhs, rhs) {
            return true
        } else if first.isLessThan(rhs, lhs) {
            return false
        }
        return second.isLessThan(lhs, rhs)
    }
}
