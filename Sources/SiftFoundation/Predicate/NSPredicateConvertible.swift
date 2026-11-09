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

// MARK: - Key paths

/// The key-value coding path of a keypath. Stops with a descriptive message when a property
/// in the keypath isn't `@objc`, which no type can express, instead of the opaque trap
/// inside Foundation.
func kvcKeyPath(_ keyPath: AnyKeyPath) -> String {
    guard let path = keyPath._kvcKeyPathString else {
        preconditionFailure(
            "Sift: \(keyPath) can't be converted for Foundation, because a property in it isn't @objc. "
                + "NSPredicate and sort descriptors use key-value coding, so every property in the keypath "
                + "must be @objc. A stored Int?, Double? or Bool? can't be @objc; use NSNumber? instead."
        )
    }
    return path
}

/// A key-path expression for `keyPath`. See ``kvcKeyPath(_:)``.
func keyPathExpression(_ keyPath: AnyKeyPath) -> NSExpression {
    NSExpression(forKeyPath: kvcKeyPath(keyPath))
}

/// A constant expression for a value, bridged as key-value coding returns it.
func constantExpression<Value: NSPredicateUsableValue>(_ value: Value) -> NSExpression {
    NSExpression(forConstantValue: value.nsPredicateConstant)
}

func comparison(
    _ lhs: NSExpression,
    _ type: NSComparisonPredicate.Operator,
    _ rhs: NSExpression,
    options: NSComparisonPredicate.Options = []
) -> NSPredicate {
    NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier: .direct, type: type, options: options)
}

// MARK: - Compound predicates

extension NSPredicate {
    fileprivate var constantValue: Bool? {
        switch predicateFormat {
        case "TRUEPREDICATE": return true
        case "FALSEPREDICATE": return false
        default: return nil
        }
    }
}

/// Joins predicates with AND or OR, keeping the result flat and minimal:
/// - operands that are already the same kind of compound are merged, so a builder with many
///   statements produces `a AND b AND c` rather than `(a AND b) AND c`;
/// - the identity constant (`TRUEPREDICATE` for AND, `FALSEPREDICATE` for OR), which empty
///   blocks and false `if` statements produce, is dropped;
/// - the absorbing constant makes the whole result that constant.
func compoundPredicate(_ type: NSCompoundPredicate.LogicalType, _ operands: [NSPredicate]) -> NSPredicate {
    precondition(type != .not, "Use NSCompoundPredicate(notPredicateWithSubpredicate:) for NOT.")
    let identity = type == .and
    var subpredicates: [NSPredicate] = []
    for operand in operands {
        if let constant = operand.constantValue {
            if constant == identity {
                continue
            }
            return NSPredicate(value: constant)
        }
        if let compound = operand as? NSCompoundPredicate, compound.compoundPredicateType == type {
            subpredicates += compound.subpredicates.map { $0 as! NSPredicate }
        } else {
            subpredicates.append(operand)
        }
    }
    switch subpredicates.count {
    case 0:
        return NSPredicate(value: identity)
    case 1:
        return subpredicates[0]
    default:
        return NSCompoundPredicate(type: type, subpredicates: subpredicates)
    }
}
