import Foundation
import SiftFoundation
import XCTest

// In-memory evaluation must select and order exactly what NSPredicate and the sort
// descriptors do, also for the edge cases where Swift's own semantics differ.

final class FoundationSemanticsTests: XCTestCase {
    let records = Record.all

    func testStringEqualityDoesNotNormalize() {
        // text 4 is the decomposed "Cafe\u{301}".
        XCTAssertEqual(assertPredicateParity(\Record.text == "Caf\u{E9}", in: records), [])
        XCTAssertEqual(assertPredicateParity(\Record.text == "Cafe\u{301}", in: records), [4])
        XCTAssertEqual(assertPredicateParity(\Record.text != "Caf\u{E9}", in: records), [1, 2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.text, ["Caf\u{E9}", "plain"]), in: records), [5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.text, ["Cafe\u{301}"]), in: records), [4])
    }

    func testStringOrderingFollowsNSString() {
        // labels: Zed, Émile, f, apple, Apple. NSString orders "Émile" next to "E".
        XCTAssertEqual(assertPredicateParity(\Record.label < "f", in: records), [1, 2, 4, 5])
        XCTAssertEqual(assertPredicateParity(\Record.label >= "f", in: records), [3])
        XCTAssertEqual(assertPredicateParity("f" > \Record.label, in: records), [1, 2, 4, 5])
        XCTAssertEqual(assertPredicateParity(\Record.label <= \Record.name, in: records), [1, 2, 5])

        let swiftOrder = records.sorted(by: \.label).map(\.id)
        let foundationOrder = (records as NSArray)
            .sortedArray(using: [NSSortDescriptor(key: "label", ascending: true)])
            .map { ($0 as! Record).id }
        XCTAssertEqual(swiftOrder, foundationOrder)
        XCTAssertEqual(swiftOrder, [5, 2, 1, 4, 3])
    }

    func testNaNComparisons() {
        // doubles: 1, NaN, 3, -1, 2
        XCTAssertEqual(assertPredicateParity(\Record.double < 0, in: records), [2, 4])
        XCTAssertEqual(assertPredicateParity(\Record.double > 0, in: records), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Record.double == \Record.double, in: records), [1, 2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(\Record.double == .nan, in: records), [2])
        XCTAssertEqual(assertPredicateParity(\Record.double != 1, in: records), [2, 3, 4, 5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.double, [.nan, 3]), in: records), [2, 3])
    }

    func testNaNOrders() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        XCTAssertEqual(assertOrderParity(Ascending(\Record.double), in: records), [4, 2, 1, 5, 3])
        XCTAssertEqual(assertOrderParity(Descending(\Record.double), in: records), [3, 5, 1, 2, 4])
        XCTAssertEqual(
            assertOrderParity(Descending(\Record.double).then(Descending(\Record.int8)), in: records),
            [3, 5, 1, 2, 4]
        )
    }

    func testXorDoesNotDuplicateOperands() {
        let a = \Record.int8 > 2
        let b = \Record.color == .red
        let c = \Record.float < 2
        let xor = Xor(a, b)
        XCTAssertEqual(xor.predicate.predicateFormat, "TERNARY(int8 > 2, 1, 0) != TERNARY(color == 0, 1, 0)")
        XCTAssertEqual(assertPredicateParity(xor, in: records), [3, 4, 5])
        let nested = Xor(Xor(a, b), c)
        // int8 > 2: T F T F T; red: T F F T F; float < 2: F T F T T
        XCTAssertEqual(assertPredicateParity(nested, in: records), [2, 3])
        // Each operand appears once, so nesting grows linearly.
        let format = nested.predicate.predicateFormat
        XCTAssertEqual(format.components(separatedBy: "int8 > 2").count - 1, 1)
        XCTAssertEqual(format.components(separatedBy: "float < 2").count - 1, 1)
    }

    func testCompoundPredicatesAreFlat() {
        let predicate = NSPredicate.build(for: Fixture.self) {
            \.rank > 1
            \.double < 4
            \.bool == true
        }
        XCTAssertEqual(predicate.predicateFormat, "rank > 1 AND double < 4 AND bool == 1")
        let anyOf = AnyOf(for: Fixture.self) {
            \.id == 1
            \.id == 2
            \.id == 3
        }
        XCTAssertEqual(anyOf.predicate.predicateFormat, "id == 1 OR id == 2 OR id == 3")
        XCTAssertEqual(assertPredicateParity(anyOf), [1, 2, 3])
    }

    func testFalseConditionsAddNoConstants() {
        func predicate(_ include: Bool) -> NSPredicate {
            NSPredicate.build(for: Fixture.self) {
                \.rank > 1
                if include {
                    \.id == 1
                }
            }
        }
        XCTAssertEqual(predicate(false).predicateFormat, "rank > 1")
        XCTAssertEqual(predicate(true).predicateFormat, "rank > 1 AND id == 1")
        let anyOf = AnyOf(for: Fixture.self) {
            \.id == 1
            if false {
                \.id == 2
            }
        }
        XCTAssertEqual(anyOf.predicate.predicateFormat, "id == 1")
        XCTAssertEqual(NSPredicate.build(for: Fixture.self) { \.id == 1; false }.predicateFormat, "FALSEPREDICATE")
        XCTAssertEqual(AnyOf(for: Fixture.self) { \.id == 1; true }.predicate.predicateFormat, "TRUEPREDICATE")
    }

    func testNSSortDescriptorsKeepTheirKeys() {
        let descriptors = Ascending(\Fixture.rank).then(Descending(\Fixture.deadline)).nsSortDescriptors
        XCTAssertEqual(descriptors.map(\.key), ["rank", "deadline"])
        XCTAssertEqual(descriptors.map(\.ascending), [true, false])
        XCTAssertEqual(Reverse(\Fixture.rank).nsSortDescriptors.map(\.ascending), [false])
    }
}
