
/// A sort order over values of type `Root`, represented as an inert value.
///
/// Like ``SiftPredicate``, an order does nothing by itself. Backends give it meaning through
/// conditional conformances, for example ``SwiftEvaluableOrder``.
public protocol Order<Root> {
    associatedtype Root
}

/// What an ``Ascending`` or ``Descending`` order sorts by, usually a keypath.
public protocol OrderOperator<Root> {
    associatedtype Root
}

extension KeyPath: Order {}
extension KeyPath: OrderOperator {}
