
/// Marker for logical negation.
public enum NotOperator {}

/// A predicate that transforms the result of another predicate, for example ``Not``.
public struct UnaryPredicate<
    Content: SiftPredicate,
    Operator
>: SiftPredicate {

    public typealias Root = Content.Root

    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }

    public init(content: Content) {
        self.content = content
    }

}

public typealias Not<Content: SiftPredicate> =
    UnaryPredicate<Content, NotOperator>

public prefix func ! <P: SiftPredicate>(content: P) -> Not<P> {
    .init(content)
}
