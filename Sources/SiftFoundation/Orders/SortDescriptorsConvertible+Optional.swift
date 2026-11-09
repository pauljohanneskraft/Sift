import Foundation

extension OptionalKeyPathOrder: SortDescriptorsConvertible
where Root: NSObject, Wrapped: SortDescriptorUsableOptionalWrapped {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<Root>] {
        sortDescriptors(ascending: true)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        nsSortDescriptors(ascending: true)
    }
}

extension OptionalKeyPathOrder: SortDescriptorsConvertibleOperator
where Root: NSObject, Wrapped: SortDescriptorUsableOptionalWrapped {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        _ = kvcKeyPath(keyPath)
        return [Wrapped.sortDescriptor(forOptional: keyPath, order: SortOrder(ascending: ascending))]
    }

    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        [NSSortDescriptor(key: kvcKeyPath(keyPath), ascending: ascending)]
    }
}
