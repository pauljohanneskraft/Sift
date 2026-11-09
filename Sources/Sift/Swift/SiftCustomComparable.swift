
/// The result of comparing two values.
public enum SiftOrdering: Equatable {
    case ascending
    case same
    case descending

    /// The result of comparing the same two values in the opposite order.
    public var reversed: SiftOrdering {
        switch self {
        case .ascending: return .descending
        case .same: return .same
        case .descending: return .ascending
        }
    }
}

/// A value type whose in-memory comparisons follow custom semantics instead of its
/// `Equatable` and `Comparable` conformances.
///
/// In-memory evaluation of `==`, `<`, ``OneOf`` and keypath orders checks for this
/// conformance at runtime. `SiftFoundation` conforms `String`, `Double`, `Float` and
/// `CGFloat`, so that `filter(by:)` and `sorted(by:)` compare those types exactly the way
/// `NSPredicate` and `NSSortDescriptor` do. Without `SiftFoundation`, Swift's own semantics
/// apply.
public protocol SiftCustomComparable {
    /// Whether two values are equal, as used by `==`, `!=` and ``OneOf``.
    static func siftIsEqual(_ lhs: Self, _ rhs: Self) -> Bool
    /// How two values are ordered, as used by `<`, `<=`, `>`, `>=` and keypath orders.
    static func siftCompare(_ lhs: Self, _ rhs: Self) -> SiftOrdering
}

extension SiftCustomComparable {
    fileprivate static func siftIsEqual(any lhs: Any, _ rhs: Any) -> Bool {
        siftIsEqual(lhs as! Self, rhs as! Self)
    }

    fileprivate static func siftCompare(any lhs: Any, _ rhs: Any) -> SiftOrdering {
        siftCompare(lhs as! Self, rhs as! Self)
    }
}

extension Optional: SiftCustomComparable where Wrapped: SiftCustomComparable {
    public static func siftIsEqual(_ lhs: Wrapped?, _ rhs: Wrapped?) -> Bool {
        switch (lhs, rhs) {
        case let (lhs?, rhs?): return Wrapped.siftIsEqual(lhs, rhs)
        case (nil, nil): return true
        default: return false
        }
    }

    /// `nil` orders before every value, as in Foundation's sort descriptors.
    public static func siftCompare(_ lhs: Wrapped?, _ rhs: Wrapped?) -> SiftOrdering {
        switch (lhs, rhs) {
        case let (lhs?, rhs?): return Wrapped.siftCompare(lhs, rhs)
        case (nil, nil): return .same
        case (nil, _): return .ascending
        case (_, nil): return .descending
        }
    }
}

/// The comparisons used by in-memory evaluation. They defer to ``SiftCustomComparable``
/// when the value type conforms.
enum SiftComparison {
    static func usesCustomSemantics<Value>(_ type: Value.Type) -> Bool {
        type is any SiftCustomComparable.Type
    }

    static func isEqual<Value: Equatable>(_ lhs: Value, _ rhs: Value) -> Bool {
        if let custom = Value.self as? any SiftCustomComparable.Type {
            return custom.siftIsEqual(any: lhs, rhs)
        }
        return lhs == rhs
    }

    static func compare<Value: Comparable>(_ lhs: Value, _ rhs: Value) -> SiftOrdering {
        if let custom = Value.self as? any SiftCustomComparable.Type {
            return custom.siftCompare(any: lhs, rhs)
        }
        if lhs < rhs {
            return .ascending
        }
        return rhs < lhs ? .descending : .same
    }
}
