
extension MembershipPredicateValue: SwiftEvaluablePredicate where Value: Equatable {
    public func evaluate(on root: Root) -> Bool {
        let value = root[keyPath: keyPath]
        if let hashedContains = hashedContains {
            return hashedContains(value)
        }
        return values.contains { SiftComparison.isEqual($0, value) }
    }
}
