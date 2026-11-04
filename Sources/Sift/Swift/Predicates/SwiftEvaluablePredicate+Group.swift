
extension PredicateGroup: SwiftEvaluablePredicate where Content: SwiftEvaluablePredicate {
    public func evaluate(on root: Root) -> Bool {
        content.evaluate(on: root)
    }
}
