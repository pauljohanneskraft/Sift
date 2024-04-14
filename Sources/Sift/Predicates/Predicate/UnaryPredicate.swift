
public enum NotOperator {}

public struct UnaryPredicate<
    Content: Predicate,
    Operator
>: Predicate {

    public typealias Root = Content.Root

    public let content: Content

    public init(content: Content) {
        self.content = content
    }

}

public typealias Not<Content: Predicate> =
    UnaryPredicate<Content, NotOperator>

public prefix func ! <P: Predicate>(content: P) -> UnaryPredicate<P, NotOperator> {
    .init(content: content)
}
