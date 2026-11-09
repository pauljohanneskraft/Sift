import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.StandardComparator {
    /// Compares two strings the way the comparator's `SortDescriptor` and `NSSortDescriptor`
    /// do, so in-memory sorting agrees with Foundation sorting.
    ///
    /// Foundation sorts `.lexical` with `NSString.compare(_:)`, which for example orders
    /// "Émile" next to "E". Swift's `.lexical` comparator orders by Unicode scalars instead,
    /// and puts "Émile" after every ASCII string.
    func foundationCompare(_ lhs: String, _ rhs: String) -> ComparisonResult {
        guard String.StandardComparator(self, order: .forward) == .lexical else {
            return compare(lhs, rhs)
        }
        let result = (lhs as NSString).compare(rhs)
        return order == .reverse ? result.reversed : result
    }

    /// Compares two optional strings like Foundation: `nil` sorts before every string in
    /// forward order, so a reversed comparator moves it to the end.
    func foundationCompare(_ lhs: String?, _ rhs: String?) -> ComparisonResult {
        let result: ComparisonResult
        switch (lhs, rhs) {
        case (nil, nil):
            return .orderedSame
        case (nil, _):
            result = .orderedAscending
        case (_, nil):
            result = .orderedDescending
        case let (lhs?, rhs?):
            return foundationCompare(lhs, rhs)
        }
        return order == .reverse ? result.reversed : result
    }
}

extension ComparisonResult {
    fileprivate var reversed: ComparisonResult {
        switch self {
        case .orderedAscending: return .orderedDescending
        case .orderedDescending: return .orderedAscending
        case .orderedSame: return .orderedSame
        }
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension StringComparatorOrderOperator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        compare(lhs, rhs) == .ascending
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        comparator.foundationCompare(lhs[keyPath: keyPath], rhs[keyPath: keyPath]).siftOrdering
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension OptionalStringComparatorOrderOperator: SwiftEvaluableOrder {
    public func isLessThan(_ lhs: Root, _ rhs: Root) -> Bool {
        compare(lhs, rhs) == .ascending
    }

    public func compare(_ lhs: Root, _ rhs: Root) -> SiftOrdering {
        comparator.foundationCompare(lhs[keyPath: keyPath], rhs[keyPath: keyPath]).siftOrdering
    }
}
