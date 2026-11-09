import XCTest
import Sift

final class PredicateEvaluationTests: XCTestCase {

    let items = Item.all

    func testKeyPathValueOperators() {
        XCTAssertEqual(items.filter(by: \.stock == 2).stocks, [2])
        XCTAssertEqual(items.filter(by: \.stock != 2).stocks, [0, 1, 3, 4])
        XCTAssertEqual(items.filter(by: \.stock < 2).stocks, [0, 1])
        XCTAssertEqual(items.filter(by: \.stock <= 2).stocks, [0, 1, 2])
        XCTAssertEqual(items.filter(by: \.stock > 2).stocks, [3, 4])
        XCTAssertEqual(items.filter(by: \.stock >= 2).stocks, [2, 3, 4])
    }

    func testValueOnTheLeftFlipsTheOperator() {
        XCTAssertEqual(items.filter(by: 2 == \.stock).stocks, [2])
        XCTAssertEqual(items.filter(by: 2 != \.stock).stocks, [0, 1, 3, 4])
        XCTAssertEqual(items.filter(by: 2 < \.stock).stocks, [3, 4])
        XCTAssertEqual(items.filter(by: 2 <= \.stock).stocks, [2, 3, 4])
        XCTAssertEqual(items.filter(by: 2 > \.stock).stocks, [0, 1])
        XCTAssertEqual(items.filter(by: 2 >= \.stock).stocks, [0, 1, 2])

        let flipped = 2 < \Item.stock
        XCTAssertTrue(type(of: flipped) == KeyPathValuePredicateValue<Item, GreaterThanOperator<Int>>.self)
    }

    func testKeyPathKeyPathOperators() {
        XCTAssertEqual(items.filter(by: \.price == \.discount).stocks, [1])
        XCTAssertEqual(items.filter(by: \.price != \.discount).stocks, [0, 2, 3, 4])
        XCTAssertEqual(items.filter(by: \.price < \.discount).stocks, [4])
        XCTAssertEqual(items.filter(by: \.price <= \.discount).stocks, [1, 4])
        XCTAssertEqual(items.filter(by: \.price > \.discount).stocks, [0, 2, 3])
        XCTAssertEqual(items.filter(by: \.price >= \.discount).stocks, [0, 1, 2, 3])
    }

    func testLogicalOperators() {
        let cheap = \Item.price < 1.5
        let inStock = \Item.stock > 0

        XCTAssertEqual(items.filter(by: cheap && inStock).stocks, [2])
        XCTAssertEqual(items.filter(by: cheap || inStock).stocks, [0, 1, 2, 3, 4])
        XCTAssertEqual(items.filter(by: !cheap).stocks, [1, 3, 4])
        XCTAssertEqual(items.filter(by: Not(cheap)).stocks, [1, 3, 4])
        XCTAssertEqual(items.filter(by: And(cheap, inStock)).stocks, [2])
        XCTAssertEqual(items.filter(by: Or(cheap, \.stock == 4)).stocks, [0, 2, 4])
        XCTAssertEqual(items.filter(by: Xor(cheap, inStock)).stocks, [0, 1, 3, 4])
        XCTAssertEqual(items.filter(by: Nand(cheap, inStock)).stocks, [0, 1, 3, 4])
        // Orange has both operands false, so Nand and Xor differ.
        XCTAssertEqual(items.filter(by: Nand(cheap, \.stock > 2)).stocks, [0, 1, 2, 3, 4])
        XCTAssertEqual(items.filter(by: Xor(cheap, \.stock > 2)).stocks, [0, 2, 3, 4])
    }

    func testLongChainTypeChecks() {
        // Regression: with the optional ordering overloads, a chain like this one failed with
        // "unable to type-check this expression in reasonable time". It must keep compiling.
        // Swift 6.0 to 6.2 handle 7 terms, as on `main`; 9 terms fail there on `main` too.
        struct Row { var a = 1.0, b = 1, c = 1.0, d = 1, e = 3.0, f = 1.0, g = 2, h = 1, i = 1 }
        let rows = [Row()]
        let seven = rows.filter(by: \.a < 5 && \.b > 0 && \.c >= 1 && \.d <= 3 && \.e > 2.5 && \.f < 9 && \.g > 1)
        XCTAssertEqual(seven.count, 1)
        #if compiler(>=6.4)
        let nine = rows.filter(
            by: \.a < 5 && \.b > 0 && \.c >= 1 && \.d <= 3 && \.e > 2.5 && \.f < 9 && \.g > 1 && \.h != 4 && \.i <= 7
        )
        XCTAssertEqual(nine.count, 1)
        #endif
    }

    func testExplicitRootKeyPathEqualityInBuilders() {
        // Regression: `\Item.price == \Item.discount` used to resolve to the standard library's
        // `AnyKeyPath ==` inside builders and became a constant `false`.
        XCTAssertEqual(items.filterPredicate { \Item.price == \Item.discount }.map(\.name), ["Orange"])
        let price = \Item.price
        let discount = \Item.discount
        XCTAssertEqual(items.filterPredicate { price == discount }.map(\.name), ["Orange"])
        XCTAssertEqual(items.filterPredicate { \Item.price == \Item.price }.count, items.count)
        XCTAssertEqual(
            items.filterPredicate {
                \Item.stock > 0
                AnyOf { \Item.price == \Item.discount; \Item.stock == 4 }
            }.map(\.name),
            ["Orange", "Kiwi"]
        )
        XCTAssertEqual(items.filterPredicate { true }.count, items.count)
        XCTAssertEqual(items.filterPredicate { false }.count, 0)
    }

    func testBooleanPredicate() {
        XCTAssertEqual(items.filter(by: BooleanPredicate<Item>(true)).count, items.count)
        XCTAssertEqual(items.filter(by: BooleanPredicate<Item>(false)).count, 0)
    }

    func testMembership() {
        XCTAssertEqual(items.filter(by: OneOf(\.stock, [1, 3, 99])).stocks, [1, 3])
        XCTAssertEqual(items.filter(by: OneOf(\.name, ["Kiwi", "Apple"])).stocks, [0, 4])
        XCTAssertEqual(items.filter(by: OneOf(\.stock, [])).stocks, [])
    }

}
