
/// A predicate that can be evaluated in memory.
public protocol SwiftEvaluablePredicate<Root>: SiftPredicate {
    associatedtype Root
    func evaluate(on root: Root) -> Bool
}
