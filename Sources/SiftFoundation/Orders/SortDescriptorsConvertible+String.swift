import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension StringComparatorOrderOperator: SortDescriptorsConvertibleOperator where Root: NSObject {
    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        sortDescriptors(ascending: ascending).map(NSSortDescriptor.init)
    }

    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [SortDescriptor(keyPath, comparator: comparator, order: ascending ? .forward : .reverse)]
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension OptionalStringComparatorOrderOperator: SortDescriptorsConvertibleOperator where Root: NSObject {
    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        sortDescriptors(ascending: ascending).map(NSSortDescriptor.init)
    }

    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [SortDescriptor(keyPath, comparator: comparator, order: ascending ? .forward : .reverse)]
    }
}
