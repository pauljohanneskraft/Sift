
public protocol SwiftEvaluableBinaryPredicateOperator {
    static func combine(_ first: Bool, with second: () -> Bool) -> Bool
}

extension BinaryPredicate: SwiftEvaluablePredicate where First: SwiftEvaluablePredicate, Second: SwiftEvaluablePredicate, Operator: SwiftEvaluableBinaryPredicateOperator {
    public func evaluate(on root: First.Root) -> Bool {
        Operator.combine(elements.first.evaluate(on: root)) {
            elements.second.evaluate(on: root)
        }
    }
}

extension AndOperator: SwiftEvaluableBinaryPredicateOperator {
    public static func combine(_ first: Bool, with second: () -> Bool) -> Bool {
        first && second()
    }
}

extension OrOperator: SwiftEvaluableBinaryPredicateOperator {
    public static func combine(_ first: Bool, with second: () -> Bool) -> Bool {
        first || second()
    }
}

extension XorOperator: SwiftEvaluableBinaryPredicateOperator {
    public static func combine(_ first: Bool, with second: () -> Bool) -> Bool {
        first != second()
    }
}

extension NandOperator: SwiftEvaluableBinaryPredicateOperator {
    public static func combine(_ first: Bool, with second: () -> Bool) -> Bool {
        !first || !second()
    }
}
