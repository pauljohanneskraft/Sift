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
