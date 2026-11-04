
/// A predicate over values of type `Root`, represented as an inert syntax tree.
///
/// A predicate does nothing by itself. Backends give it meaning through conditional
/// conformances, for example ``SwiftEvaluablePredicate`` for in-memory evaluation, or
/// `NSPredicateConvertible` in `SiftFoundation`.
///
/// It is named `SiftPredicate` rather than `Predicate` so that it doesn't collide with
/// Foundation's `Predicate`.
public protocol SiftPredicate<Root> {
    associatedtype Root

    /// A marker type that identifies the kind of node. Backends key their behavior off it.
    associatedtype Operator
}
