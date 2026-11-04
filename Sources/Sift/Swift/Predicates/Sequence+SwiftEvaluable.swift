
extension Sequence {
    /// Returns the elements that satisfy `predicate`.
    public func filter<P: SwiftEvaluablePredicate>(
        by predicate: P
    ) -> [Element] where P.Root == Element {
        filter { predicate.evaluate(on: $0) }
    }

    /// Returns the elements that satisfy every statement in `build`, which are joined with AND.
    ///
    /// ```swift
    /// items.filterPredicate {
    ///     \.price < 5
    ///     if !searchText.isEmpty {
    ///         \.name == searchText
    ///     }
    /// }
    /// ```
    public func filterPredicate<P: SwiftEvaluablePredicate>(
        @PredicateGroupBuilder<Element, AndOperator> _ build: () -> P
    ) -> [Element] where P.Root == Element {
        filter(by: build())
    }
}
