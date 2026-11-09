import Foundation

// Only the members that produce `SortDescriptor` require macOS 12 / iOS 15. The conformances
// themselves aren't gated, so `nsSortDescriptors`, which only needs `NSSortDescriptor`, works
// on every OS version.

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
///
/// Every property in the keypath must still be `@objc`. A stored `Int?`, `Double?` or
/// `Bool?` can't be `@objc`, so an optional of those types only works through optional
/// chaining, as in `\.parent?.rank`. Converting a keypath to a non-`@objc` property stops
/// with a message that names the keypath.
public protocol SortDescriptorUsableValue {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Self>,
        order: SortOrder
    ) -> SortDescriptor<Root>
}

/// A value type whose optional form `SortDescriptor` can sort by keypath.
///
/// Swift allows `Optional` only one conditional conformance to `SortDescriptorUsableValue`,
/// so the optional case is forwarded through this protocol on the wrapped type.
public protocol SortDescriptorUsableOptionalWrapped {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Self?>,
        order: SortOrder
    ) -> SortDescriptor<Root>
}

extension Optional: SortDescriptorUsableValue where Wrapped: SortDescriptorUsableOptionalWrapped {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Wrapped?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        Wrapped.sortDescriptor(forOptional: keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension SortOrder {
    init(ascending: Bool) {
        self = ascending ? .forward : .reverse
    }
}

extension KeyPath: SortDescriptorsConvertible where Root: NSObject, Value: SortDescriptorUsableValue {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public var sortDescriptors: [SortDescriptor<Root>] {
        sortDescriptors(ascending: true)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        nsSortDescriptors(ascending: true)
    }
}

extension KeyPath: SortDescriptorsConvertibleOperator where Root: NSObject, Value: SortDescriptorUsableValue {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        _ = kvcKeyPath(self)
        return [Value.sortDescriptor(for: self, order: SortOrder(ascending: ascending))]
    }

    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        [NSSortDescriptor(key: kvcKeyPath(self), ascending: ascending)]
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
        self.order.nsSortDescriptors.map { descriptor in
            // `reversedSortDescriptor` is always an `NSSortDescriptor` for an `NSSortDescriptor`.
            descriptor.reversedSortDescriptor as! NSSortDescriptor
        }
    }
}
