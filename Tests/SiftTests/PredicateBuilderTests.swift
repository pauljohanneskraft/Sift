import XCTest
import Sift

final class PredicateBuilderTests: XCTestCase {

    let items = Item.all

    func testEmptyGroupsUseTheIdentity() {
        XCTAssertEqual(items.filter(by: AllOf(for: Item.self) {}).count, items.count)
        XCTAssertEqual(items.filter(by: AnyOf(for: Item.self) {}).count, 0)
        XCTAssertEqual(items.filterPredicate {}.count, items.count)
    }

    func testBooleanStatements() {
        XCTAssertEqual(items.filterPredicate { false }.count, 0)
        XCTAssertEqual(items.filterPredicate { true; \.stock > 2 }.stocks, [3, 4])
    }

    func testStatementsAreJoinedWithAnd() {
        let result = items.filterPredicate {
            \.price >= 1
            \.stock < 4
            \.price != \.discount
        }
        XCTAssertEqual(result.stocks, [0, 3])
    }

    func testAnyOfJoinsWithOr() {
        let predicate = AnyOf(for: Item.self) {
            \.stock == 0
            \.stock == 3
        }
        XCTAssertEqual(items.filter(by: predicate).stocks, [0, 3])
    }

    func testNestedGroupsInferTheirRoot() {
        let result = items.filterPredicate {
            \.price < 3
            AnyOf {
                \.stock == 0
                \.name == "Kiwi"
                AllOf {
                    \.rating == 2
                    \.price < 1
                }
            }
        }
        XCTAssertEqual(result.stocks, [0, 2, 4])
    }

    func testIfWithoutElse() {
        func search(_ text: String, inStockOnly: Bool) -> [Int] {
            items.filterPredicate {
                if !text.isEmpty {
                    \.name == text
                }
                if inStockOnly {
                    \.stock > 0
                }
            }.stocks
        }
        XCTAssertEqual(search("", inStockOnly: false), [0, 1, 2, 3, 4])
        XCTAssertEqual(search("", inStockOnly: true), [1, 2, 3, 4])
        XCTAssertEqual(search("Apple", inStockOnly: false), [0])
        XCTAssertEqual(search("Apple", inStockOnly: true), [])
    }

    func testIfWithoutElseInsideAnyOfDoesNotMatchEverything() {
        let includeKiwi = false
        let predicate = AnyOf(for: Item.self) {
            \.stock == 0
            if includeKiwi {
                \.name == "Kiwi"
            }
        }
        XCTAssertEqual(items.filter(by: predicate).stocks, [0])
    }

    func testIfElse() {
        func filter(cheap: Bool) -> [Int] {
            items.filterPredicate {
                if cheap {
                    \.price < 1.5
                } else {
                    \.price >= 1.5
                    \.stock > 1
                }
            }.stocks
        }
        XCTAssertEqual(filter(cheap: true), [0, 2])
        XCTAssertEqual(filter(cheap: false), [3, 4])
    }

}
