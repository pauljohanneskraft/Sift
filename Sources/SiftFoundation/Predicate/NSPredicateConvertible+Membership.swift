import Foundation

extension MembershipPredicateValue: NSPredicateConvertible
where Root: NSObject, Value: Equatable & NSPredicateUsableValue {
    // `IN` never matches a `nil` property, even when the list contains `NSNull`, while the
    // in-memory `values.contains(nil)` does. So a `nil` element becomes `OR key == nil`.
    public var predicate: NSPredicate {
        let key = keyPathExpression(keyPath)
        var constants: [Any] = []
        var containsNil = false
        for value in values {
            if let constant = value.nsPredicateConstant {
                constants.append(constant)
            } else {
                containsNil = true
            }
        }
        let membership = comparison(key, .in, NSExpression(forConstantValue: constants))
        guard containsNil else {
            return membership
        }
        return compoundPredicate(.or, [membership, comparison(key, .equalTo, NSExpression(forConstantValue: nil))])
    }
}
