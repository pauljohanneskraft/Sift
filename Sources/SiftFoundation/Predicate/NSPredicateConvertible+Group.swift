import Foundation

extension PredicateGroup: NSPredicateConvertible where Content: NSPredicateConvertible {
    public var predicate: NSPredicate {
        content.predicate
    }
}

extension EitherPredicate: NSPredicateConvertible
where First: NSPredicateConvertible, Second: NSPredicateConvertible {
    public var predicate: NSPredicate {
        switch self {
        case .first(let predicate):
            return predicate.predicate
        case .second(let predicate):
            return predicate.predicate
        }
    }
}
