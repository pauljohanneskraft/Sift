
extension KeyPath: SwiftEvaluableOrder where Value: Comparable {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        compare(lhs, rhs) == .ascending
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        SiftComparison.compare(lhs[keyPath: self], rhs[keyPath: self])
    }
}

extension Ascending: SwiftEvaluableOrder where Operator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        self.operator.isLessThan(lhs, rhs)
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        self.operator.compare(lhs, rhs)
    }
}

extension Descending: SwiftEvaluableOrder where Operator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        self.operator.isLessThan(rhs, lhs)
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        self.operator.compare(rhs, lhs)
    }
}

extension Reverse: SwiftEvaluableOrder where O: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        self.order.isLessThan(rhs, lhs)
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        self.order.compare(rhs, lhs)
    }
}
