
/// An array of orders is an order that applies its elements in sequence: later elements
/// only break ties left by earlier ones.
extension Array: Order where Element: Order {
    public typealias Root = Element.Root
}

extension ArraySlice: Order where Element: Order {
    public typealias Root = Element.Root
}
