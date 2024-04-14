
public protocol SortDescriptorsConvertibleOperator<Root> {
    associatedtype Root

    @available(macOS 12.0, *)
    func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>]
    func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor]
}

@available(macOS 12.0, *)
public protocol SortDescriptorUsableValue {
    static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Self>,
        order: SortOrder
    ) -> SortDescriptor<Root>
}

@available(macOS 12.0, *)
extension Bool: SortDescriptorUsableValue {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Bool>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12.0, *)
extension KeyPath: SortDescriptorsConvertible where Root: NSObject, Value: SortDescriptorUsableValue {
    public var sortDescriptors: [SortDescriptor<Root>] {
        [Value.sortDescriptor(for: self, order: .forward)]
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        [.init(keyPath: self, ascending: true)]
    }
}

@available(macOS 12.0, *)
extension KeyPath: SortDescriptorsConvertibleOperator where Root: NSObject, Value: SortDescriptorUsableValue {
    public func sortDescriptors(ascending: Bool) -> [SortDescriptor<Root>] {
        [Value.sortDescriptor(for: self, order: ascending ? .forward : .reverse)]
    }

    public func nsSortDescriptors(ascending: Bool) -> [NSSortDescriptor] {
        [.init(keyPath: self, ascending: ascending)]
    }
}

extension Ascending: SortDescriptorsConvertible where Operator: SortDescriptorsConvertibleOperator {
    @available(macOS 12.0, *)
    public var sortDescriptors: [SortDescriptor<Operator.Root>] {
        self.operator.sortDescriptors(ascending: true)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        self.operator.nsSortDescriptors(ascending: true)
    }
}

extension Descending: SortDescriptorsConvertible where Operator: SortDescriptorsConvertibleOperator {
    @available(macOS 12.0, *)
    public var sortDescriptors: [SortDescriptor<Operator.Root>] {
        self.operator.sortDescriptors(ascending: false)
    }

    public var nsSortDescriptors: [NSSortDescriptor] {
        self.operator.nsSortDescriptors(ascending: false)
    }
}

extension Reverse: SortDescriptorsConvertible where O: SortDescriptorsConvertible {
    @available(macOS 12.0, *)
    public var sortDescriptors: [SortDescriptor<O.Root>] {
        self.order.sortDescriptors.map { descriptor in
            var copy = descriptor
            copy.order = .reverse
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
