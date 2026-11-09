import Foundation

/// An order that can be converted into Foundation sort descriptors.
///
/// Orders over `NSObject` subclasses with `@objc` properties conform, because
/// `NSSortDescriptor` goes through key-value coding.
public protocol SortDescriptorsConvertible<Root>: Order {
    associatedtype Root

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    var sortDescriptors: [SortDescriptor<Root>] { get }

    var nsSortDescriptors: [NSSortDescriptor] { get }
}

extension Array: SortDescriptorsConvertible where Element: SortDescriptorsConvertible {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<Element.Root>] {
        flatMap { $0.sortDescriptors }
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        flatMap { $0.nsSortDescriptors }
    }
}

extension ArraySlice: SortDescriptorsConvertible where Element: SortDescriptorsConvertible {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<Element.Root>] {
        flatMap { $0.sortDescriptors }
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        flatMap { $0.nsSortDescriptors }
    }
}

extension Array where Element == NSSortDescriptor {
    /// Builds `NSSortDescriptor`s with ``OrderBuilder``.
    public static func build<Root, O: SortDescriptorsConvertible>(
        for root: Root.Type = Root.self,
        @OrderBuilder<Root> using order: () -> O
    ) -> [NSSortDescriptor] where O.Root == Root {
        order().nsSortDescriptors
    }
}

extension Array {
    /// Builds `SortDescriptor`s with ``OrderBuilder``.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public static func build<Root, O: SortDescriptorsConvertible>(
        for root: Root.Type = Root.self,
        @OrderBuilder<Root> using order: () -> O
    ) -> [SortDescriptor<Root>] where Element == SortDescriptor<Root>, O.Root == Root {
        order().sortDescriptors
    }
}
