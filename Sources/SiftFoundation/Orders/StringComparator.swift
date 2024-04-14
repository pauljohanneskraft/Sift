
import Foundation

@available(macOS 12.0, *)
public struct StringComparatorOrderOperator<Root>: OrderOperator {
    public let keyPath: KeyPath<Root, String>
    public let comparator: String.StandardComparator
}

@available(macOS 12.0, *)
public struct OptionalStringComparatorOrderOperator<Root>: OrderOperator {
    public let keyPath: KeyPath<Root, String?>
    public let comparator: String.StandardComparator
}

@available(macOS 12.0, *)
extension Ascending where StringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}

@available(macOS 12.0, *)
extension Descending where StringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}

@available(macOS 12.0, *)
extension Ascending where OptionalStringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String?>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}

@available(macOS 12.0, *)
extension Descending where OptionalStringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String?>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}
