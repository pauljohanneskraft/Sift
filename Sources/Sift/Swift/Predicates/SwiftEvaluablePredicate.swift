
public protocol SwiftEvaluablePredicate: Predicate {
    func evaluate(on root: Root) -> Bool
}
