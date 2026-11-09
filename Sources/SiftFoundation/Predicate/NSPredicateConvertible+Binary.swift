import Foundation

public protocol NSPredicateConvertibleBinaryPredicateOperator {
    static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate
}

extension BinaryPredicate: NSPredicateConvertible
where First: NSPredicateConvertible, Second: NSPredicateConvertible, Operator: NSPredicateConvertibleBinaryPredicateOperator {
    public var predicate: NSPredicate {
        Operator.combine(elements.first.predicate, with: elements.second.predicate)
    }
}

extension AndOperator: NSPredicateConvertibleBinaryPredicateOperator {
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        compoundPredicate(.and, [first, second])
    }
}

extension OrOperator: NSPredicateConvertibleBinaryPredicateOperator {
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        compoundPredicate(.or, [first, second])
    }
}

extension XorOperator: NSPredicateConvertibleBinaryPredicateOperator {
    /// `TERNARY(A, 1, 0) != TERNARY(B, 1, 0)`. Written with only AND, OR and NOT, XOR needs
    /// each operand twice, so nested `Xor`s would double in size at every level. Conditional
    /// expressions are evaluated in memory and by Core Data's SQLite store.
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        func bit(_ predicate: NSPredicate) -> NSExpression {
            NSExpression(
                forConditional: predicate,
                trueExpression: NSExpression(forConstantValue: 1),
                falseExpression: NSExpression(forConstantValue: 0)
            )
        }
        return comparison(bit(first), .notEqualTo, bit(second))
    }
}

extension NandOperator: NSPredicateConvertibleBinaryPredicateOperator {
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(notPredicateWithSubpredicate: compoundPredicate(.and, [first, second]))
    }
}
