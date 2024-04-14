
import Foundation

extension BooleanPredicate: NSPredicateConvertible {
    public var predicate: NSPredicate {
        .init(value: value)
    }
}
