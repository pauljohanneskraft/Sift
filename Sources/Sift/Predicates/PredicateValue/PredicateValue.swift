
public protocol PredicateValueOperator {
    associatedtype Value
}

public protocol PredicateValue<Root, Operator>: Predicate where Operator: PredicateValueOperator {
    associatedtype Value
}

extension PredicateValue {
    public typealias Value = Operator.Value
}

public enum EqualOperator<Value>: PredicateValueOperator {}
public enum GreaterThanOperator<Value>: PredicateValueOperator {}
public enum LessThanOperator<Value>: PredicateValueOperator {}
public enum GreaterThanOrEqualOperator<Value>: PredicateValueOperator {}
public enum LessThanOrEqualOperator<Value>: PredicateValueOperator {}
public enum NotEqualOperator<Value>: PredicateValueOperator {}
