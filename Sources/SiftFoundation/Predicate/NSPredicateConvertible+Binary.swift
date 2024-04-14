
import Foundation

public protocol NSPredicateConvertibleBinaryPredicateOperator {
    static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate
}

extension BinaryPredicate: NSPredicateConvertible where First: NSPredicateConvertible, Second: NSPredicateConvertible, Operator: NSPredicateConvertibleBinaryPredicateOperator {
    public var predicate: NSPredicate {
        Operator.combine(elements.first.predicate, with: elements.second.predicate)
    }
}

extension AndOperator: NSPredicateConvertibleBinaryPredicateOperator {
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [first, second])
    }
}

extension OrOperator: NSPredicateConvertibleBinaryPredicateOperator {
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [first, second])
    }
}

extension NandOperator: NSPredicateConvertibleBinaryPredicateOperator {
    public static func combine(_ first: NSPredicate, with second: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(
            notPredicateWithSubpredicate: NSCompoundPredicate(
                andPredicateWithSubpredicates: [first, second]
            )
        )
    }
}
