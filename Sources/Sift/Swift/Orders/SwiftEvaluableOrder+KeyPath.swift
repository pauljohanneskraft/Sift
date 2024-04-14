
extension KeyPath: SwiftEvaluableOrder where Value: Comparable {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        lhs[keyPath: self] < rhs[keyPath: self]
    }
}

extension Ascending: SwiftEvaluableOrder where Operator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        self.operator.isLessThan(lhs, rhs)
    }
}

extension Descending: SwiftEvaluableOrder where Operator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        self.operator.isLessThan(rhs, lhs)
    }
}

extension Reverse: SwiftEvaluableOrder where O: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        self.order.isLessThan(rhs, lhs)
    }
}
