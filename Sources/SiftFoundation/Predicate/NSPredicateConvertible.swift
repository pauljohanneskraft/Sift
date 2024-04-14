
import Foundation

public protocol NSPredicateConvertible {
    var predicate: NSPredicate { get }
}

extension NSPredicate: NSPredicateConvertible {
    public var predicate: NSPredicate {
        self
    }
}
