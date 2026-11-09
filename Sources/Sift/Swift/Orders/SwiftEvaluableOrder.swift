
/// An order that can be evaluated in memory.
///
/// Conform by implementing ``isLessThan(_:_:)``. Implement ``compare(_:_:)`` as well when a
/// three-way comparison is cheaper than two `isLessThan` calls; concatenated orders and
/// arrays of orders use it to read each value once per comparison.
public protocol SwiftEvaluableOrder<Root>: Order {
    associatedtype Root
    func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool
    func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering
}

extension SwiftEvaluableOrder {
    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        if isLessThan(lhs, rhs) {
            return .ascending
        }
        return isLessThan(rhs, lhs) ? .descending : .same
    }
}
