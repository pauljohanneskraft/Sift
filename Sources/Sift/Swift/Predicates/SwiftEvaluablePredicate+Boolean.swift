
extension BooleanPredicate: SwiftEvaluablePredicate {
    public func evaluate(on root: Root) -> Bool {
        value
    }
}
