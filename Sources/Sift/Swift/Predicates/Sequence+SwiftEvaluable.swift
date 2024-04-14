
extension Sequence {
    public func filter<P: SwiftEvaluablePredicate>(
        by predicate: P
    ) -> [Element] where P.Root == Element {
        filter { predicate.evaluate(on: $0) }
    }

    func filterPredicate<P: SwiftEvaluablePredicate>(
        as: P.Type = P.self,
        @PredicateBuilder<P> build: () -> P
    ) -> [Element] where P.Root == Element {
        let predicate = build()
        return filter { predicate.evaluate(on: $0) }
    }
}
