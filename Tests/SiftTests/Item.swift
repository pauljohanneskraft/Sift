
struct Item: Equatable {
    var name: String
    var price: Double
    var discount: Double
    var stock: Int
    var rating: Int?
    var previousRating: Int?

    static let all: [Item] = [
        Item(name: "Apple", price: 1.0, discount: 0.5, stock: 0, rating: 4, previousRating: 3),
        Item(name: "Orange", price: 1.5, discount: 1.5, stock: 1, rating: nil, previousRating: 2),
        Item(name: "Banana", price: 0.5, discount: 0.0, stock: 2, rating: 2, previousRating: nil),
        Item(name: "Mango", price: 3.0, discount: 1.0, stock: 3, rating: 5, previousRating: 5),
        Item(name: "Kiwi", price: 2.0, discount: 2.5, stock: 4, rating: nil, previousRating: nil),
    ]
}

extension Sequence where Element == Item {
    var stocks: [Int] { map(\.stock) }
}
