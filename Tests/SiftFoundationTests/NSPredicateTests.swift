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
        // Rows 2 and 4 have both operands false, so Nand, Xor and And all differ.
        XCTAssertEqual(assertPredicateParity(Nand(\Fixture.bool == true, highRank)), [2, 4])
        XCTAssertEqual(assertPredicateParity(And(\Fixture.bool == true, highRank)), [1, 3, 5])
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
        func predicate(category: String?, cheap: Bool) -> some SwiftEvaluablePredicate<Fixture> & NSPredicateConvertible {
            AllOf(for: Fixture.self) {
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
        XCTAssertEqual(assertPredicateParity(predicate(category: nil, cheap: true)), [2, 4])
        XCTAssertEqual(assertPredicateParity(predicate(category: "fruit", cheap: false)), [1])
        XCTAssertEqual(assertPredicateParity(predicate(category: "drink", cheap: true)), [])
        XCTAssertEqual(
            predicate(category: "fruit", cheap: true).predicate.predicateFormat,
            NSPredicate.build(for: Fixture.self) { \.category == "fruit"; \.double < 2 }.predicateFormat
        )
    }

    func testExplicitRootKeyPathEqualityInBuilders() {
        // Regression: these used to resolve to the standard library's `AnyKeyPath ==` and
        // became TRUEPREDICATE or FALSEPREDICATE.
        XCTAssertEqual(NSPredicate.build(for: Fixture.self) { \Fixture.id == \Fixture.rank }.predicateFormat, "id == rank")
        let id = \Fixture.id
        let rank = \Fixture.rank
        XCTAssertEqual(NSPredicate.build(for: Fixture.self) { id == rank }.predicateFormat, "id == rank")
        let predicate = AllOf(for: Fixture.self) {
            \Fixture.rank > 1
            \Fixture.id == \Fixture.rank
        }
        XCTAssertEqual(predicate.predicate.predicateFormat, "rank > 1 AND id == rank")
        XCTAssertEqual(assertPredicateParity(predicate), [2, 3, 5])
        XCTAssertEqual(NSPredicate.build(for: Fixture.self) { true }.predicateFormat, "TRUEPREDICATE")
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
        XCTAssertEqual(assertPredicateParity(\Fixture.deadline > Fixture.day(2)), [1, 4])
        XCTAssertEqual(assertPredicateParity(\Fixture.nickname > "b"), [3])
    }

    func testMembership() {
        XCTAssertEqual(assertPredicateParity(OneOf(\Fixture.id, [2, 4, 9])), [2, 4])
        XCTAssertEqual(assertPredicateParity(OneOf(\Fixture.category, ["drink", "vegetable"])), [3, 5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Fixture.id, [])), [])
    }

}
