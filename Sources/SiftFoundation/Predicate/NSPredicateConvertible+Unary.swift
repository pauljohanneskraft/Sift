public protocol NSPredicateConvertibleUnaryOperator {
    static func transform(_ value: NSPredicate) -> NSPredicate
}

extension NotOperator: NSPredicateConvertibleUnaryOperator {
    public static func transform(_ value: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(notPredicateWithSubpredicate: value)
    }
}

extension UnaryPredicate: NSPredicateConvertible where Content: NSPredicateConvertible, Operator: NSPredicateConvertibleUnaryOperator {
    public var predicate: NSPredicate {
        Operator.transform(content.predicate)
    }
}
