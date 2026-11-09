/// Marker for logical negation.
public enum NotOperator {}

/// A predicate that transforms the result of another predicate, for example ``Not``.
///
/// `Root` is a generic parameter for the same reason as in ``BinaryPredicate``: it lets the
/// type checker push an enclosing root down into the content.
public struct UnaryPredicate<
    Root,
    Content: SiftPredicate<Root>,
    Operator
>: SiftPredicate {

    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }

    public init(content: Content) {
        self.content = content
    }

}

public typealias Not<Root, Content: SiftPredicate<Root>> =
    UnaryPredicate<Root, Content, NotOperator>

public prefix func ! <Root, P: SiftPredicate<Root>>(content: P) -> Not<Root, P> {
    .init(content)
}
