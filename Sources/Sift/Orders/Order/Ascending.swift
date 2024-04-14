
public struct Ascending<Root, Operator: OrderOperator<Root>>: Order {
    public typealias Root = Operator.Root

    public let `operator`: Operator

    public init(_ op: Operator) {
        self.operator = op
    }
}

extension Ascending where Operator == KeyPath<Root, Root> {
    public init() {
        self.init(\Root.self)
    }
}
