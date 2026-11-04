import Foundation

extension ConcatenatedOrder: SortDescriptorsConvertible where First: SortDescriptorsConvertible, Second: SortDescriptorsConvertible {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<First.Root>] {
        first.sortDescriptors + second.sortDescriptors
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        first.nsSortDescriptors + second.nsSortDescriptors
    }
}
