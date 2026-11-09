import Foundation
import SiftFoundation
import XCTest

// Mirrors the README's `SiftFoundation` example. Update both together.

private final class Product: NSObject {
    @objc var name: String
    @objc var price: Double
    @objc var category: String

    init(name: String, price: Double, category: String) {
        self.name = name
        self.price = price
        self.category = category
    }
}

final class FoundationReadmeExamplesTests: XCTestCase {

    func testFoundationExample() throws {
        let predicate = NSPredicate.build(for: Product.self) {
            \.price < 5
            AnyOf {
                \.category == "fruit"
                HasPrefix(\.name, "cafe", options: [.caseInsensitive, .diacriticInsensitive])
            }
        }
        XCTAssertEqual(
            predicate.predicateFormat,
            "price < 5 AND (category == \"fruit\" OR name BEGINSWITH[cd] \"cafe\")"
        )

        let products = [
            Product(name: "Café Latte", price: 4, category: "drink"),
            Product(name: "Apple", price: 1, category: "fruit"),
            Product(name: "Tea", price: 3, category: "drink"),
            Product(name: "Durian", price: 9, category: "fruit"),
        ]
        XCTAssertEqual(products.filter { predicate.evaluate(with: $0) }.map(\.name), ["Café Latte", "Apple"])

        let nsSortDescriptors = [NSSortDescriptor].build(for: Product.self) {
            Descending(\.price)
            Ascending(\.name, comparator: .localizedStandard)
        }
        XCTAssertEqual(nsSortDescriptors.map(\.key), ["price", "name"])

        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        let sortDescriptors = [SortDescriptor<Product>].build {
            Descending(\.price)
        }
        XCTAssertEqual(products.sorted(using: sortDescriptors).map(\.name), ["Durian", "Café Latte", "Tea", "Apple"])
    }

}

final class FoundationReadmeStringExamplesTests: XCTestCase {
    func testMatchingStringsThemselves() {
        let words = ["apple", "Kiwi", "Avocado"].filterPredicate {
            Contains("a", options: .caseInsensitive)
        }
        XCTAssertEqual(words, ["apple", "Avocado"])
    }
}
