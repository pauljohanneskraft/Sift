import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension String.StandardComparator {
    /// The descriptor order: the comparator's own order, flipped for a descending sort.
    /// Passing `ascending ? .forward : .reverse` would discard a comparator built with
    /// `order: .reverse`, while in-memory sorting honors it.
    func sortOrder(ascending: Bool) -> SortOrder {
        if ascending {
            return order
        }
        return order == .forward ? .reverse : .forward
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension StringComparatorOrderOperator: SortDescriptorsConvertibleOperator where Root: NSObject {
    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        sortDescriptors(ascending: ascending).map(NSSortDescriptor.init)
    }

    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [SortDescriptor(keyPath, comparator: comparator, order: comparator.sortOrder(ascending: ascending))]
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension OptionalStringComparatorOrderOperator: SortDescriptorsConvertibleOperator where Root: NSObject {
    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        sortDescriptors(ascending: ascending).map(NSSortDescriptor.init)
    }

    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [SortDescriptor(keyPath, comparator: comparator, order: comparator.sortOrder(ascending: ascending))]
    }
}
