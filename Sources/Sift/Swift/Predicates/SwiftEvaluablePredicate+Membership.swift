
extension MembershipPredicateValue: SwiftEvaluablePredicate where Value: Equatable {
    public func evaluate(on root: Root) -> Bool {
        values.contains(root[keyPath: keyPath])
    }
}
