
import Foundation

/// Orders by a string keypath with a `String.StandardComparator`, for example `.localizedStandard`.
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public struct StringComparatorOrderOperator<Root>: OrderOperator {
    public let keyPath: KeyPath<Root, String>
    public let comparator: String.StandardComparator
}

/// Orders by an optional string keypath with a `String.StandardComparator`. `nil` sorts first.
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public struct OptionalStringComparatorOrderOperator<Root>: OrderOperator {
    public let keyPath: KeyPath<Root, String?>
    public let comparator: String.StandardComparator
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Ascending where StringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Descending where StringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Ascending where OptionalStringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String?>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Descending where OptionalStringComparatorOrderOperator<Root> == Operator {
    public init(
        _ keyPath: KeyPath<Root, String?>,
        comparator: String.StandardComparator
    ) {
        self.init(.init(keyPath: keyPath, comparator: comparator))
    }
}
