import XCTest
import Sift

// Mirrors the README's `Sift` examples so they keep compiling and stay correct.
// Update both together.

private struct ReadmeItem { // `Item` in the README
    var name: String
    var price: Double
    var stock: Int
    var rating: Int?
}

private let items = [
    ReadmeItem(name: "Apple", price: 1.0, stock: 3, rating: 4),
    ReadmeItem(name: "Orange", price: 1.5, stock: 0, rating: nil),
    ReadmeItem(name: "Banana", price: 0.5, stock: 7, rating: 5),
]

final class ReadmeExamplesTests: XCTestCase {

    func testIntroduction() {
        let affordable = items.filterPredicate {
            \.price < 5
            \.stock > 0
        }
        XCTAssertEqual(affordable.map(\.name), ["Apple", "Banana"])

        let sorted = items.sortedOrder {
            Descending(\.rating)
            \.price
        }
        XCTAssertEqual(sorted.map(\.name), ["Banana", "Apple", "Orange"])
    }

    func testPredicates() {
        let cheap = items.filter(by: \.price < 1.2)
        let available = items.filter(by: \.stock > 0 && !(\.price > 1.2))
        let either = items.filter(by: Xor(\.price < 1.2, \.stock == 0))
        let named = items.filter(by: OneOf(\.name, ["Apple", "Kiwi"]))
        XCTAssertEqual(cheap.map(\.name), ["Apple", "Banana"])
        XCTAssertEqual(available.map(\.name), ["Apple", "Banana"])
        XCTAssertEqual(either.map(\.name), ["Apple", "Orange", "Banana"])
        XCTAssertEqual(named.map(\.name), ["Apple"])

        let wellRated = items.filter(by: \.rating >= 4)
        let unrated = items.filter(by: \.rating == nil)
        XCTAssertEqual(wellRated.map(\.name), ["Apple", "Banana"])
        XCTAssertEqual(unrated.map(\.name), ["Orange"])
    }

    func testPredicateBuilders() {
        func search(_ text: String, inStockOnly: Bool) -> [ReadmeItem] {
            items.filterPredicate {
                \.price < 2
                if !text.isEmpty {
                    \.name == text
                }
                if inStockOnly {
                    AnyOf {
                        \.stock > 0
                        \.rating == 5
                    }
                }
            }
        }
        XCTAssertEqual(search("", inStockOnly: false).map(\.name), ["Apple", "Orange", "Banana"])
        XCTAssertEqual(search("", inStockOnly: true).map(\.name), ["Apple", "Banana"])
        XCTAssertEqual(search("Orange", inStockOnly: true).map(\.name), [])
    }

    func testSortOrders() {
        let byPrice = items.sorted(by: \.price)
        let byPriceDescending = items.sorted(by: Descending(\.price))
        let byStockThenPrice = items.sorted(by: Descending(\.stock).then(Ascending(\.price)))
        let byStockDescendingThenName = items.sortedOrder {
            Reverse {
                \.stock
            }
            \.name
        }
        XCTAssertEqual(byPrice.map(\.name), ["Banana", "Apple", "Orange"])
        XCTAssertEqual(byPriceDescending.map(\.name), ["Orange", "Apple", "Banana"])
        XCTAssertEqual(byStockThenPrice.map(\.name), ["Banana", "Apple", "Orange"])
        XCTAssertEqual(byStockDescendingThenName.map(\.name), ["Banana", "Apple", "Orange"])
    }

}
