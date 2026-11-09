import XCTest
import Sift

final class OrderEvaluationTests: XCTestCase {

    let items = Item.all

    func testKeyPathOrders() {
        XCTAssertEqual(items.sorted(by: \.price).stocks, [2, 0, 1, 4, 3])
        XCTAssertEqual(items.sorted(by: Ascending(\.price)).stocks, [2, 0, 1, 4, 3])
        XCTAssertEqual(items.sorted(by: Descending(\.price)).stocks, [3, 4, 1, 0, 2])
        XCTAssertEqual([3, 1, 2].sorted(by: Ascending()), [1, 2, 3])
        XCTAssertEqual([3, 1, 2].sorted(by: Descending()), [3, 2, 1])
    }

    func testReverse() {
        XCTAssertEqual(items.sorted(by: Reverse(Ascending(\.price))).stocks, [3, 4, 1, 0, 2])
        XCTAssertEqual(items.sorted(by: Reverse(Descending(\.price))).stocks, [2, 0, 1, 4, 3])
        XCTAssertEqual([3, 1, 2].sorted(by: Reverse()), [3, 2, 1])
    }

    func testConcatenationBreaksTies() {
        let pairs = [(1, "b"), (0, "c"), (1, "a"), (0, "a")].map { Pair(number: $0.0, letter: $0.1) }
        let sorted = pairs.sorted(by: Ascending(\.number).then(Descending(\.letter)))
        XCTAssertEqual(sorted.map(\.description), ["0c", "0a", "1b", "1a"])

        let reversed = pairs.sorted(by: Reverse(Ascending(\.number).then(Descending(\.letter))))
        XCTAssertEqual(reversed.map(\.description), ["1a", "1b", "0a", "0c"])
    }

    func testOrderBuilder() {
        let pairs = [(1, "b"), (0, "c"), (1, "a"), (0, "a")].map { Pair(number: $0.0, letter: $0.1) }
        let sorted = pairs.sortedOrder {
            Descending(\.number)
            \.letter
        }
        XCTAssertEqual(sorted.map(\.description), ["1a", "1b", "0a", "0c"])

        let nested = [3, 1, 2].sortedOrder {
            Reverse {
                \Int.self
            }
            Descending(\Int.self)
        }
        XCTAssertEqual(nested, [3, 2, 1])
    }

    func testArrayOfOrders() {
        let pairs = [(1, "b"), (0, "c"), (1, "a"), (0, "a")].map { Pair(number: $0.0, letter: $0.1) }
        let sorted = pairs.sorted(by: [Descending(\Pair.number), Descending(\Pair.number)] + [])
        XCTAssertEqual(sorted.map(\.number), [1, 1, 0, 0])

        let byLetterThenNumber = pairs.sorted(by: [\Pair.letter])
        XCTAssertEqual(byLetterThenNumber.map(\.letter), ["a", "a", "b", "c"])
    }

}

private struct Pair: CustomStringConvertible {
    var number: Int
    var letter: String
    var description: String { "\(number)\(letter)" }
}

final class OrderInferenceTests: XCTestCase {
    func testNestedReverseInfersItsRoot() {
        let sorted = Item.all.sortedOrder {
            Reverse {
                \.price
            }
        }
        XCTAssertEqual(sorted.stocks, [3, 4, 1, 0, 2])
        XCTAssertEqual(Item.all.sorted(by: Reverse(\.price)).stocks, [3, 4, 1, 0, 2])
    }
}

final class OptionalOrderTests: XCTestCase {
    // ratings by stock: 0: 4, 1: nil, 2: 2, 3: 5, 4: nil
    func testNilSortsFirst() {
        XCTAssertEqual(Item.all.sortedOrder { \.rating; \.stock }.stocks, [1, 4, 2, 0, 3])
        XCTAssertEqual(Item.all.sorted(by: Ascending(\.rating).then(Ascending(\.stock))).stocks, [1, 4, 2, 0, 3])
        XCTAssertEqual(Item.all.sorted(by: Descending(\.rating).then(Ascending(\.stock))).stocks, [3, 0, 2, 1, 4])
        XCTAssertEqual(Item.all.sorted(by: Reverse(\.rating)).prefix(3).stocks, [3, 0, 2])
        XCTAssertEqual(Item.all.sorted(by: \.rating).suffix(3).stocks, [2, 0, 3])
    }

    func testStoredOptionalOrders() {
        // Regression: outside a call, `Ascending(\Item.rating)` used the keypath itself as the
        // operator, which can't be sorted in memory because `Int?` isn't `Comparable`.
        let ascending = Ascending(\Item.rating)
        XCTAssertTrue(type(of: ascending) == Ascending<Item, OptionalKeyPathOrder<Item, Int>>.self)
        XCTAssertEqual(Item.all.sorted(by: ascending.then(Ascending(\.stock))).stocks, [1, 4, 2, 0, 3])

        let descending = Descending(\Item.rating)
        XCTAssertEqual(Item.all.sorted(by: descending.then(Ascending(\.stock))).stocks, [3, 0, 2, 1, 4])

        let reversed = Reverse(\Item.rating)
        XCTAssertEqual(Item.all.sorted(by: reversed).prefix(3).stocks, [3, 0, 2])

        let keyPath = \Item.rating
        XCTAssertEqual(Item.all.sorted(by: Ascending(keyPath).then(Ascending(\.stock))).stocks, [1, 4, 2, 0, 3])

        // Non-optional keypaths are unaffected.
        let byPrice = Ascending(\Item.price)
        XCTAssertEqual(Item.all.sorted(by: byPrice).map(\.price), [0.5, 1.0, 1.5, 2.0, 3.0])
    }
}

final class OrderArrayLiteralTests: XCTestCase {
    // (price, discount, stock): (1.0, 0.5, 0), (1.5, 1.5, 1), (0.5, 0.0, 2), (3.0, 1.0, 3), (2.0, 2.5, 4)
    func testArrayLiteralsInBuilders() {
        XCTAssertEqual(Item.all.sortedOrder { [Ascending(\.price), Ascending(\.discount)] }.stocks, [2, 0, 1, 4, 3])
        XCTAssertEqual(Item.all.sortedOrder { [Descending(\.price), Descending(\.discount)] }.stocks, [3, 4, 1, 0, 2])
        XCTAssertEqual(Item.all.sortedOrder { [Reverse(\.discount), Reverse(\.price)] }.stocks, [4, 1, 3, 0, 2])
        XCTAssertEqual(Item.all.sortedOrder { [\.discount, \.price] }.stocks, [2, 0, 3, 1, 4])
        XCTAssertEqual(Item.all.sortedOrder { Reverse { [Descending(\.price), Descending(\.discount)] } }.stocks, [2, 0, 1, 4, 3])
        XCTAssertEqual(Item.all.sortedOrder { [Ascending(\.rating), Ascending(\.previousRating)]; \.stock }.stocks, [4, 1, 2, 0, 3])
    }

    func testCustomOrderWithOnlyIsLessThan() {
        struct ByNameLength: SwiftEvaluableOrder {
            typealias Root = Item
            func isLessThan(_ lhs: Item, _ rhs: Item) -> Bool { lhs.name.count < rhs.name.count }
        }
        // name lengths: Apple 5, Orange 6, Banana 6, Mango 5, Kiwi 4
        XCTAssertEqual(Item.all.sorted(by: [ByNameLength()]).map(\.name).first, "Kiwi")
        XCTAssertEqual(Item.all.sortedOrder { ByNameLength(); \.stock }.stocks, [4, 0, 3, 1, 2])
        XCTAssertEqual(ByNameLength().compare(Item.all[0], Item.all[3]), .same)
    }
}

final class MembershipLookupTests: XCTestCase {
    struct Tag: Equatable { let name: String }
    struct Tagged { let tag: Tag; let id: Int }

    func testHashableAndEquatableValues() {
        XCTAssertEqual(Item.all.filter(by: OneOf(\.stock, [0, 3, 9])).stocks, [0, 3])
        XCTAssertEqual(Item.all.filter(by: OneOf(\.rating, [nil, 5])).stocks, [1, 3, 4])
        XCTAssertEqual(Item.all.filter(by: !OneOf(\.stock, [0, 3])).stocks, [1, 2, 4])
        // A value that is only `Equatable` uses the linear scan.
        let tagged = [Tagged(tag: Tag(name: "a"), id: 1), Tagged(tag: Tag(name: "b"), id: 2)]
        XCTAssertEqual(tagged.filter(by: OneOf(\.tag, [Tag(name: "b")])).map(\.id), [2])
    }
}
