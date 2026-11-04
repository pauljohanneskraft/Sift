import Foundation

/// A value that can be converted into an `NSPredicate`.
///
/// Predicates over `NSObject` subclasses with `@objc` properties conform, because the
/// conversion goes through key-value coding.
public protocol NSPredicateConvertible {
    var predicate: NSPredicate { get }
}

extension NSPredicate: NSPredicateConvertible {
    public var predicate: NSPredicate {
        self
    }
}

extension NSPredicate {
    /// Builds an `NSPredicate` whose statements are joined with AND.
    ///
    /// ```swift
    /// let predicate = NSPredicate.build(for: Item.self) {
    ///     \.price < 5
    ///     AnyOf {
    ///         \.category == "fruit"
    ///         \.category == "vegetable"
    ///     }
    /// }
    /// ```
    public static func build<Root, P: SiftPredicate & NSPredicateConvertible>(
        for root: Root.Type = Root.self,
        @PredicateGroupBuilder<Root, AndOperator> _ build: () -> P
    ) -> NSPredicate where P.Root == Root {
        build().predicate
    }
}

/// Builds a constant expression. A `nil` optional becomes a real `nil` constant, so a
/// comparison renders as `x == nil` rather than comparing against a boxed optional.
func constantExpression<Value>(_ value: Value) -> NSExpression {
    if let optional = value as? OptionalConstant {
        return NSExpression(forConstantValue: optional.wrappedConstant)
    }
    return NSExpression(forConstantValue: value)
}

private protocol OptionalConstant {
    var wrappedConstant: Any? { get }
}

extension Optional: OptionalConstant {
    fileprivate var wrappedConstant: Any? {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            return nil
        }
    }
}
