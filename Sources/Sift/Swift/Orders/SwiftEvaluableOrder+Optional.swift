
extension OptionalKeyPathOrder: SwiftEvaluableOrder where Wrapped: Comparable {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        switch (lhs[keyPath: keyPath], rhs[keyPath: keyPath]) {
        case let (lhsValue?, rhsValue?):
            return lhsValue < rhsValue
        case (nil, _?):
            return true
        case (_, nil):
            return false
        }
    }
}

extension Sequence {
    /// Returns the elements sorted in ascending order of the optional value at `keyPath`,
    /// with `nil` first.
    public func sorted<Wrapped: Comparable>(by keyPath: KeyPath<Element, Wrapped?>) -> [Element] {
        sorted(by: OptionalKeyPathOrder(keyPath))
    }
}
