
extension EitherPredicate: SwiftEvaluablePredicate
where First: SwiftEvaluablePredicate, Second: SwiftEvaluablePredicate {
    public func evaluate(on root: First.Root) -> Bool {
        switch self {
        case .first(let predicate):
            return predicate.evaluate(on: root)
        case .second(let predicate):
            return predicate.evaluate(on: root)
        }
    }
}
