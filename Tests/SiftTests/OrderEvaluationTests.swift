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
}
