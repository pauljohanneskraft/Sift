import Foundation

/// An order operator, such as a keypath, that can produce sort descriptors in either direction.
public protocol SortDescriptorsConvertibleOperator<Root> {
    associatedtype Root

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>]
    func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor]
}

/// A value type that Foundation's `SortDescriptor` can sort by keypath.
///
/// `Bool`, the integer types, `Double`, `Float`, `Date` and `UUID` conform, and so do their
/// optionals. Strings are sorted with a comparator instead; see
/// `Ascending(_:comparator:)`.
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public protocol SortDescriptorUsableValue {
    static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Self>,
        order: SortOrder
    ) -> SortDescriptor<Root>
}

/// A value type whose optional form `SortDescriptor` can sort by keypath.
///
/// Swift allows `Optional` only one conditional conformance to `SortDescriptorUsableValue`,
/// so the optional case is forwarded through this protocol on the wrapped type.
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public protocol SortDescriptorUsableOptionalWrapped {
    static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Self?>,
        order: SortOrder
    ) -> SortDescriptor<Root>
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Optional: SortDescriptorUsableValue where Wrapped: SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Wrapped?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        Wrapped.sortDescriptor(forOptional: keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension KeyPath: SortDescriptorsConvertible where Root: NSObject, Value: SortDescriptorUsableValue {
    public var sortDescriptors: [SortDescriptor<Root>] {
        [Value.sortDescriptor(for: self, order: .forward)]
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        [.init(keyPath: self, ascending: true)]
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension KeyPath: SortDescriptorsConvertibleOperator where Root: NSObject, Value: SortDescriptorUsableValue {
    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [Value.sortDescriptor(for: self, order: ascending ? .forward : .reverse)]
    }

    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        [.init(keyPath: self, ascending: ascending)]
    }
}

extension Ascending: SortDescriptorsConvertible where Operator: SortDescriptorsConvertibleOperator {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<Operator.Root>] {
        self.operator.sortDescriptors(ascending: true)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        self.operator.nsSortDescriptors(ascending: true)
    }
}

extension Descending: SortDescriptorsConvertible where Operator: SortDescriptorsConvertibleOperator {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<Operator.Root>] {
        self.operator.sortDescriptors(ascending: false)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        self.operator.nsSortDescriptors(ascending: false)
    }
}

extension Reverse: SortDescriptorsConvertible where O: SortDescriptorsConvertible {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<O.Root>] {
        self.order.sortDescriptors.map { descriptor in
            var copy = descriptor
            copy.order = descriptor.order == .forward ? .reverse : .forward
            return copy
        }
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        self.order.nsSortDescriptors.compactMap { descriptor in
            guard let reversedDescriptor = descriptor.reversedSortDescriptor as? NSSortDescriptor else {
                assertionFailure("Reversal of NSSortDescriptor failed.")
                return nil
            }
            return reversedDescriptor
        }
    }
}
