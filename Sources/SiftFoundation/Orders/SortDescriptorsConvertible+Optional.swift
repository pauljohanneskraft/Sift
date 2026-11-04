import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension OptionalKeyPathOrder: SortDescriptorsConvertible
where Root: NSObject, Wrapped: SortDescriptorUsableOptionalWrapped {
    public var sortDescriptors: [SortDescriptor<Root>] {
        sortDescriptors(ascending: true)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        nsSortDescriptors(ascending: true)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension OptionalKeyPathOrder: SortDescriptorsConvertibleOperator
where Root: NSObject, Wrapped: SortDescriptorUsableOptionalWrapped {
    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [Wrapped.sortDescriptor(forOptional: keyPath, order: ascending ? .forward : .reverse)]
    }

    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: keyPath, ascending: ascending)]
    }
}
