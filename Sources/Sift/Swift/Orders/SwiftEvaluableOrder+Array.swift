
extension Sequence where Element: SwiftEvaluableOrder {
    fileprivate func lexicographicallyLess(_ lhs: Element.Root, _ rhs: Element.Root) -> Bool {
        for order in self {
            if order.isLessThan(lhs, rhs) {
                return true
            } else if order.isLessThan(rhs, lhs) {
                return false
            }
        }
        return false
    }
}

extension Array: SwiftEvaluableOrder where Element: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Element.Root, _ rhs: Element.Root) -> Bool {
        lexicographicallyLess(lhs, rhs)
    }
}

extension ArraySlice: SwiftEvaluableOrder where Element: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Element.Root, _ rhs: Element.Root) -> Bool {
        lexicographicallyLess(lhs, rhs)
    }
}
