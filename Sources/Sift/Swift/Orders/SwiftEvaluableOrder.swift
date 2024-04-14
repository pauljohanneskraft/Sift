
public protocol SwiftEvaluableOrder: Order {
    func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool
}
