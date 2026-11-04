
/// An order that can be evaluated in memory.
public protocol SwiftEvaluableOrder<Root>: Order {
    associatedtype Root
    func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool
}
