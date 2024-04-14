
public protocol Order<Root> {
    associatedtype Root
}

public protocol OrderOperator<Root> {
    associatedtype Root
}

extension KeyPath: Order {}
extension KeyPath: OrderOperator {}
