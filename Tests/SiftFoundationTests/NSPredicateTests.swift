import Foundation
import SiftFoundation
import XCTest

final class NSPredicateTests: XCTestCase {

    func testOrProducesAnOrPredicate() {
        let predicate = (\Fixture.id == 1) || (\Fixture.id == 2)
        XCTAssertEqual(predicate.predicate.predicateFormat, "id == 1 OR id == 2")
        XCTAssertEqual(assertPredicateParity(predicate), [1, 2])
    }

    func testAndAndNotFormats() {
        XCTAssertEqual(((\Fixture.id > 1) && (\Fixture.rank < 3)).predicate.predicateFormat, "id > 1 AND rank < 3")
        XCTAssertEqual((!(\Fixture.id == 1)).predicate.predicateFormat, "NOT id == 1")
    }

    func testValueComparisons() {
        XCTAssertEqual(assertPredicateParity(\Fixture.rank == 3), [1, 3])
        XCTAssertEqual(assertPredicateParity(\Fixture.rank != 3), [2, 4, 5])
        XCTAssertEqual(assertPredicateParity(\Fixture.rank < 3), [2, 4])
        XCTAssertEqual(assertPredicateParity(\Fixture.rank <= 3), [1, 2, 3, 4])
        XCTAssertEqual(assertPredicateParity(\Fixture.rank > 3), [5])
        XCTAssertEqual(assertPredicateParity(\Fixture.rank >= 3), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(3 < \Fixture.rank), [5])
        XCTAssertEqual(assertPredicateParity(\Fixture.double >= 2.5), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Fixture.bool == true), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Fixture.name == "Banana"), [2])
        XCTAssertEqual(assertPredicateParity(\Fixture.date < Fixture.day(3)), [1, 3])
    }

    func testKeyPathComparisons() {
        // (id, rank): (1, 3), (2, 2), (3, 3), (4, 1), (5, 5)
        XCTAssertEqual(assertPredicateParity(\Fixture.id == \Fixture.rank), [2, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Fixture.id != \Fixture.rank), [1, 4])
        XCTAssertEqual(assertPredicateParity(\Fixture.id < \Fixture.rank), [1])
        XCTAssertEqual(assertPredicateParity(\Fixture.id <= \Fixture.rank), [1, 2, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Fixture.id > \Fixture.rank), [4])
        XCTAssertEqual(assertPredicateParity(\Fixture.id >= \Fixture.rank), [2, 3, 4, 5])
    }

    func testLogicalOperators() {
        let fruit = \Fixture.category == "fruit"
        let highRank = \Fixture.rank >= 3
        XCTAssertEqual(assertPredicateParity(fruit && highRank), [1])
        XCTAssertEqual(assertPredicateParity(fruit || highRank), [1, 2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(!fruit), [3, 5])
        XCTAssertEqual(assertPredicateParity(Xor(fruit, highRank)), [2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(Nand(fruit, highRank)), [2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(Xor(\Fixture.bool == true, highRank)), [])
    }

    func testBuilders() {
        let predicate = AllOf(for: Fixture.self) {
            \.double > 1
            AnyOf {
                \.category == "fruit"
                \.name == "Carrot"
            }
        }
        XCTAssertEqual(assertPredicateParity(predicate), [1, 4, 5])
        XCTAssertEqual(
            predicate.predicate.predicateFormat,
            "double > 1 AND (category == \"fruit\" OR name == \"Carrot\")"
        )
        XCTAssertEqual(assertPredicateParity(AllOf(for: Fixture.self) {}), [1, 2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(AnyOf(for: Fixture.self) {}), [])
    }

    func testBuilderConditionals() {
        func predicate(category: String?, cheap: Bool) -> NSPredicate {
            NSPredicate.build(for: Fixture.self) {
                if let category = category {
                    \.category == category
                }
                if cheap {
                    \.double < 2
                } else {
                    \.double >= 2
                }
            }
        }
        func ids(_ predicate: NSPredicate) -> [Int] {
            Fixture.all.filter { predicate.evaluate(with: $0) }.map(\.id)
        }
        XCTAssertEqual(ids(predicate(category: nil, cheap: true)), [2, 4])
        XCTAssertEqual(ids(predicate(category: "fruit", cheap: false)), [1])
        XCTAssertEqual(ids(predicate(category: "drink", cheap: true)), [])
    }

    func testNilConstants() {
        XCTAssertEqual((\Fixture.nickname == nil).predicate.predicateFormat, "nickname == nil")
        XCTAssertEqual(assertPredicateParity(\Fixture.nickname == nil), [2, 4])
        XCTAssertEqual(assertPredicateParity(\Fixture.nickname != nil), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Fixture.nickname == "coffee"), [3])
    }

    func testOptionalComparisons() {
        // deadlines (days): 3, nil, 1, 6, nil
        XCTAssertEqual(assertPredicateParity(\Fixture.deadline < Fixture.day(4)), [1, 3])
        XCTAssertEqual(assertPredicateParity(\Fixture.deadline >= Fixture.day(3)), [1, 4])
        XCTAssertEqual(assertPredicateParity(Fixture.day(2) < \Fixture.deadline), [1, 4])
        XCTAssertEqual(assertPredicateParity(\Fixture.nickname > "b"), [3])
    }

    func testMembership() {
        XCTAssertEqual(assertPredicateParity(OneOf(\Fixture.id, [2, 4, 9])), [2, 4])
        XCTAssertEqual(assertPredicateParity(OneOf(\Fixture.category, ["drink", "vegetable"])), [3, 5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Fixture.id, [])), [])
    }

}
