
/// The operator of a comparison between a keypath and a value, or between two keypaths.
public protocol PredicateValueOperator {
    associatedtype Value
}

public enum EqualOperator<Value>: PredicateValueOperator {}
public enum NotEqualOperator<Value>: PredicateValueOperator {}
public enum GreaterThanOperator<Value>: PredicateValueOperator {}
public enum LessThanOperator<Value>: PredicateValueOperator {}
public enum GreaterThanOrEqualOperator<Value>: PredicateValueOperator {}
public enum LessThanOrEqualOperator<Value>: PredicateValueOperator {}

/// Applies `Base` to optional values. If either side is `nil`, the comparison is `false`,
/// which matches how `NSPredicate` treats `nil` in ordering comparisons.
public enum OptionalComparison<Base: PredicateValueOperator>: PredicateValueOperator {
    public typealias Value = Base.Value?
}
