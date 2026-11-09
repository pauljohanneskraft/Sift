
extension OptionalKeyPathOrder: SwiftEvaluableOrder where Wrapped: Comparable {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        compare(lhs, rhs) == .ascending
    }

    /// `nil` orders before every value, as in Foundation's sort descriptors.
    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        switch (lhs[keyPath: keyPath], rhs[keyPath: keyPath]) {
        case let (lhsValue?, rhsValue?):
            return SiftComparison.compare(lhsValue, rhsValue)
        case (nil, nil):
            return .same
        case (nil, _?):
            return .ascending
        case (_?, nil):
            return .descending
        }
    }
}

extension Sequence {
    /// Returns the elements sorted in ascending order of the optional value at `keyPath`,
    /// with `nil` first.
    ///
    /// Disfavored, so that an app's own `sorted(by:)` keypath helper takes precedence
    /// instead of making the call ambiguous.
    @_disfavoredOverload
    public func sorted<Wrapped: Comparable>(by keyPath: KeyPath<Element, Wrapped?>) -> [Element] {
        sorted(by: OptionalKeyPathOrder(keyPath))
    }
}
