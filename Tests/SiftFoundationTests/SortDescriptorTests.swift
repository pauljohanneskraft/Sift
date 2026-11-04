import Foundation
import SiftFoundation
import XCTest

final class SortDescriptorTests: XCTestCase {
    // id: 1...5, rank: 3 2 3 1 5, double: 2.5 0.5 4.0 1.5 3.0, day: 1 5 2 4 7

    func testReverseFlipsTheDirection() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        XCTAssertEqual(Reverse(Descending(\Fixture.bool)).sortDescriptors.map(\.order), [.forward])
        XCTAssertEqual(Reverse(Ascending(\Fixture.bool)).sortDescriptors.map(\.order), [.reverse])
        XCTAssertEqual(Reverse(Descending(\Fixture.bool)).nsSortDescriptors.map(\.ascending), [true])
        XCTAssertEqual(Reverse(Reverse(Ascending(\Fixture.bool))).sortDescriptors.map(\.order), [.forward])
    }

    func testValueTypes() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        XCTAssertEqual(assertOrderParity(Ascending(\Fixture.id)), [1, 2, 3, 4, 5])
        XCTAssertEqual(assertOrderParity(Descending(\Fixture.double)), [3, 5, 1, 4, 2])
        XCTAssertEqual(assertOrderParity(Ascending(\Fixture.date)), [1, 3, 4, 2, 5])
        XCTAssertEqual(assertOrderParity(\Fixture.double), [2, 4, 1, 5, 3])
        XCTAssertEqual(assertOrderParity(Reverse(\Fixture.date)), [5, 2, 4, 3, 1])
    }

    func testConcatenation() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        XCTAssertEqual(assertOrderParity(Descending(\Fixture.rank).then(Ascending(\Fixture.double))), [5, 1, 3, 2, 4])
        XCTAssertEqual(assertOrderParity(Reverse(Descending(\Fixture.rank).then(Ascending(\Fixture.double)))), [4, 2, 3, 1, 5])
        XCTAssertEqual(assertOrderParity([Descending(\Fixture.rank), Descending(\Fixture.id)]), [5, 3, 1, 2, 4])
    }

    func testBuilders() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        let ns = [NSSortDescriptor].build(for: Fixture.self) {
            Descending(\.rank)
            \.double
        }
        XCTAssertEqual(ns.map(\.key), ["rank", "double"])
        XCTAssertEqual(ns.map(\.ascending), [false, true])

        let descriptors = [SortDescriptor<Fixture>].build {
            Descending(\.rank)
            Reverse {
                \.double
            }
        }
        XCTAssertEqual(Fixture.all.sorted(using: descriptors).map(\.id), [5, 3, 1, 2, 4])
    }

    func testStringComparator() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        // Localized standard comparison ignores case: Apple, apricot, Banana, Café, Carrot.
        XCTAssertEqual(assertOrderParity(Ascending(\Fixture.name, comparator: .localizedStandard)), [1, 4, 2, 3, 5])
        XCTAssertEqual(assertOrderParity(Descending(\Fixture.name, comparator: .localizedStandard)), [5, 3, 2, 4, 1])
    }

    func testOptionalValues() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        let order = Ascending(\Fixture.deadline).then(Ascending(\Fixture.id))
        let foundation = Fixture.all.sorted(using: order.sortDescriptors).map(\.id)
        let nsFoundation = (Fixture.all as NSArray).sortedArray(using: order.nsSortDescriptors).map { ($0 as! Fixture).id }
        XCTAssertEqual(foundation, nsFoundation)
        // deadlines (days): 3, nil, 1, 6, nil. nil sorts first.
        XCTAssertEqual(foundation, [2, 5, 3, 1, 4])
    }

}

final class OptionalSortDescriptorTests: XCTestCase {
    func testOptionalOrderParity() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        // deadlines (days): 3, nil, 1, 6, nil
        XCTAssertEqual(assertOrderParity(Ascending(\Fixture.deadline).then(Ascending(\Fixture.id))), [2, 5, 3, 1, 4])
        XCTAssertEqual(assertOrderParity(Descending(\Fixture.deadline).then(Ascending(\Fixture.id))), [4, 1, 3, 2, 5])
    }
}
