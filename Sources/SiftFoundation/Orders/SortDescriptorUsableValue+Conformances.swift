import Foundation

// Each type forwards to the matching concrete `SortDescriptor` initializer, which Foundation
// provides for `NSObject` roots.

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Bool: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Bool>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Bool?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Double: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Double>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Double?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Float: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Float>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Float?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Int: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Int>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Int?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Int8: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Int8>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Int8?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Int16: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Int16>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Int16?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Int32: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Int32>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Int32?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Int64: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Int64>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Int64?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension UInt: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, UInt>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, UInt?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension UInt8: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, UInt8>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, UInt8?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension UInt16: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, UInt16>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, UInt16?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension UInt32: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, UInt32>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, UInt32?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension UInt64: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, UInt64>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, UInt64?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Date: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, Date>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, Date?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension UUID: SortDescriptorUsableValue, SortDescriptorUsableOptionalWrapped {
    public static func sortDescriptor<Root: NSObject>(
        for keyPath: KeyPath<Root, UUID>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }

    public static func sortDescriptor<Root: NSObject>(
        forOptional keyPath: KeyPath<Root, UUID?>,
        order: SortOrder
    ) -> SortDescriptor<Root> {
        .init(keyPath, order: order)
    }
}
