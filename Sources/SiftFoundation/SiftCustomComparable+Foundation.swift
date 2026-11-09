import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// In-memory comparisons that match `NSPredicate` and `NSSortDescriptor` exactly. With these
// conformances, `filter(by:)` and `sorted(by:)` from `Sift` use Foundation semantics for these
// types whenever `SiftFoundation` is part of the program.
//
// - Strings: `NSPredicate` tests `==`, `!=` and `IN` with `NSString.isEqual(to:)`, which
//   doesn't apply Unicode normalization, and orders with `NSString.compare(_:)`. Swift
//   compares by canonical equivalence and orders by Unicode scalars.
// - Floating point: `NSPredicate` and `NSSortDescriptor` compare through `NSNumber.compare(_:)`,
//   which orders NaN and treats it as equal to itself. Swift's `<` and `==` are false for NaN.
//
// Module-qualified names mark these as intentional cross-module conformances (SE-0364).

extension ComparisonResult {
    var siftOrdering: SiftOrdering {
        switch self {
        case .orderedAscending: return .ascending
        case .orderedSame: return .same
        case .orderedDescending: return .descending
        }
    }
}

extension Swift.String: Sift.SiftCustomComparable {
    public static func siftIsEqual(_ lhs: String, _ rhs: String) -> Bool {
        (lhs as NSString).isEqual(to: rhs)
    }

    public static func siftCompare(_ lhs: String, _ rhs: String) -> SiftOrdering {
        (lhs as NSString).compare(rhs).siftOrdering
    }
}

/// Compares like `NSNumber.compare(_:)`. Only NaN needs `NSNumber`; every other value
/// compares the same way in Swift, without allocating.
private func numberCompare(_ lhs: Double, _ rhs: Double) -> SiftOrdering {
    if lhs.isNaN || rhs.isNaN {
        return NSNumber(value: lhs).compare(NSNumber(value: rhs)).siftOrdering
    }
    if lhs < rhs {
        return .ascending
    }
    return lhs > rhs ? .descending : .same
}

extension Swift.Double: Sift.SiftCustomComparable {
    public static func siftIsEqual(_ lhs: Double, _ rhs: Double) -> Bool {
        numberCompare(lhs, rhs) == .same
    }

    public static func siftCompare(_ lhs: Double, _ rhs: Double) -> SiftOrdering {
        numberCompare(lhs, rhs)
    }
}

extension Swift.Float: Sift.SiftCustomComparable {
    public static func siftIsEqual(_ lhs: Float, _ rhs: Float) -> Bool {
        numberCompare(Double(lhs), Double(rhs)) == .same
    }

    public static func siftCompare(_ lhs: Float, _ rhs: Float) -> SiftOrdering {
        numberCompare(Double(lhs), Double(rhs))
    }
}

#if canImport(CoreGraphics)
extension CoreGraphics.CGFloat: Sift.SiftCustomComparable {
    public static func siftIsEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
        numberCompare(Double(lhs), Double(rhs)) == .same
    }

    public static func siftCompare(_ lhs: CGFloat, _ rhs: CGFloat) -> SiftOrdering {
        numberCompare(Double(lhs), Double(rhs))
    }
}
#endif
