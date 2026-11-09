import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// A value type that `NSPredicate` can compare through key-value coding.
///
/// Comparisons, ``OneOf`` and orders only convert to Foundation for values of these types,
/// so a type that key-value coding can't represent fails to compile instead of failing at
/// runtime. `Decimal`, for example, doesn't conform: an `@objc` `Decimal` property crashes
/// inside key-value coding. Use `NSDecimalNumber` instead.
///
/// The standard scalar types, `String`, `Date`, `Data`, `UUID`, `URL`, every `NSObject`
/// subclass, and optionals of all of these conform. To use an `@objc enum`, declare the
/// conformance; the raw value is used as the constant:
///
/// ```swift
/// @objc enum Status: Int { case active, archived }
/// extension Status: NSPredicateUsableValue {}
/// ```
public protocol NSPredicateUsableValue {
    /// The object key-value coding returns for this value, used as an `NSPredicate` constant.
    var nsPredicateConstant: Any? { get }
}

extension NSPredicateUsableValue where Self: RawRepresentable, RawValue: NSPredicateUsableValue {
    public var nsPredicateConstant: Any? {
        rawValue.nsPredicateConstant
    }
}

extension Optional: NSPredicateUsableValue where Wrapped: NSPredicateUsableValue {
    public var nsPredicateConstant: Any? {
        self?.nsPredicateConstant ?? nil
    }
}

extension NSObject: NSPredicateUsableValue {
    public var nsPredicateConstant: Any? { self }
}

extension Bool: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Int: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Int8: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Int16: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Int32: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Int64: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension UInt: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension UInt8: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension UInt16: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension UInt32: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension UInt64: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Double: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Float: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension String: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Date: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension Data: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension UUID: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
extension URL: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
#if canImport(CoreGraphics)
extension CGFloat: NSPredicateUsableValue { public var nsPredicateConstant: Any? { self } }
#endif
