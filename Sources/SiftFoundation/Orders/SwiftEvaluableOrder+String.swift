
@available(macOS 12.0, *)
extension StringComparatorOrderOperator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        comparator.compare(lhs[keyPath: keyPath], rhs[keyPath: keyPath]) == .orderedAscending
    }
}

@available(macOS 12.0, *)
extension OptionalStringComparatorOrderOperator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        guard let lhsValue = lhs[keyPath: keyPath] else {
            return rhs[keyPath: keyPath] != nil
        }
        guard let rhsValue = rhs[keyPath: keyPath] else {
            return false
        }
        return comparator.compare(lhsValue, rhsValue) == .orderedAscending
    }
}
