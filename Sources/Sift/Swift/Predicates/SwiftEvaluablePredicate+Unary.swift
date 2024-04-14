
public protocol SwiftEvaluableUnaryPredicateOperator {
    static func transform(_ value: Bool) -> Bool
}

extension NotOperator: SwiftEvaluableUnaryPredicateOperator {
    public static func transform(_ value: Bool) -> Bool {
        !value
    }
}

extension UnaryPredicate: SwiftEvaluablePredicate where Content: SwiftEvaluablePredicate, Operator: SwiftEvaluableUnaryPredicateOperator {
    public func evaluate(on root: Content.Root) -> Bool {
        Operator.transform(content.evaluate(on: root))
    }
}
