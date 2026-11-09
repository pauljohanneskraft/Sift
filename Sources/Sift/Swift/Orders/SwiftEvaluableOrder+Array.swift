
// Arrays and slices of orders compare element by element; each later order only breaks ties.
// The shared implementation lives on `Sequence`, so `Array` and `ArraySlice` stay in sync.

extension Sequence where Element: SwiftEvaluableOrder {
    fileprivate func lexicographicCompare(_ lhs: Element.Root, _ rhs: Element.Root) -> SiftOrdering {
        for order in self {
            let result = order.compare(lhs, rhs)
            if result != .same {
                return result
            }
        }
        return .same
    }
}

extension Array: SwiftEvaluableOrder where Element: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Element.Root, _ rhs: Element.Root) -> Bool {
        lexicographicCompare(lhs, rhs) == .ascending
    }

    public func compare(_ lhs: Element.Root, _ rhs: Element.Root) -> SiftOrdering {
        lexicographicCompare(lhs, rhs)
    }
}

extension ArraySlice: SwiftEvaluableOrder where Element: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Element.Root, _ rhs: Element.Root) -> Bool {
        lexicographicCompare(lhs, rhs) == .ascending
    }

    public func compare(_ lhs: Element.Root, _ rhs: Element.Root) -> SiftOrdering {
        lexicographicCompare(lhs, rhs)
    }
}
