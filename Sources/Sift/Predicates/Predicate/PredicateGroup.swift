
/// A combinator that a ``PredicateGroupBuilder`` uses to join its statements.
public protocol PredicateGroupCombinator {
    /// The value of an empty group: `true` for AND, `false` for OR.
    static var identity: Bool { get }
}

extension AndOperator: PredicateGroupCombinator {
    public static var identity: Bool { true }
}

extension OrOperator: PredicateGroupCombinator {
    public static var identity: Bool { false }
}

/// A group of predicates built with a ``PredicateGroupBuilder``.
///
/// Use it through ``AllOf`` (statements joined with AND) or ``AnyOf`` (joined with OR):
///
/// ```swift
/// AllOf(for: Item.self) {
///     \.price < 5
///     AnyOf {
///         \.category == "fruit"
///         \.category == "vegetable"
///     }
/// }
/// ```
///
/// `Root` is a generic parameter, not derived from `Content`, so that a nested group can
/// infer it from the enclosing builder.
public struct PredicateGroup<
    Root,
    Content: SiftPredicate<Root>,
    Combinator: PredicateGroupCombinator
>: SiftPredicate {
    public typealias Operator = Combinator

    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }

    /// Builds the group's content. The root type is inferred from an enclosing builder or
    /// call; pass `for:` when there is none.
    public init(
        for root: Root.Type = Root.self,
        @PredicateGroupBuilder<Root, Combinator> _ build: () -> Content
    ) {
        self.content = build()
    }
}

/// A group whose statements must all be true.
public typealias AllOf<Root, Content: SiftPredicate<Root>> = PredicateGroup<Root, Content, AndOperator>

/// A group of which at least one statement must be true.
public typealias AnyOf<Root, Content: SiftPredicate<Root>> = PredicateGroup<Root, Content, OrOperator>
