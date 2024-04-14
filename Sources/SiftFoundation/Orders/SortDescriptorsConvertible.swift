
public protocol SortDescriptorsConvertible: Order {

    @available(macOS 12.0, *)
    var sortDescriptors: [SortDescriptor<Root>] { get }

    var nsSortDescriptors: [NSSortDescriptor] { get }
}

extension RandomAccessCollection where Element: SortDescriptorsConvertible {
    public typealias Root = Element.Root

    @available(macOS 12.0, *)
    public var sortDescriptors: [SortDescriptor<Element.Root>] {
        reduce([]) { $0 + $1.sortDescriptors }
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        reduce([]) { $0 + $1.nsSortDescriptors }
    }
}

extension Array: Order, SortDescriptorsConvertible where Element: SortDescriptorsConvertible {}
extension ArraySlice: Order, SortDescriptorsConvertible where Element: SortDescriptorsConvertible {}

extension Array<NSSortDescriptor> {

    public static func build<O: Order & SortDescriptorsConvertible>(
        for type: O.Root.Type = O.Root.self,
        @OrderBuilder<O.Root> using order: () -> O
    ) -> Self {
        order().nsSortDescriptors
    }

}
