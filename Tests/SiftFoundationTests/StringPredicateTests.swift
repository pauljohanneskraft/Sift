import Foundation
import SiftFoundation
import XCTest

final class StringPredicateTests: XCTestCase {
    // names: Apple, Banana, Café, apricot, Carrot

    func testContains() {
        XCTAssertEqual(assertPredicateParity(Contains(\Fixture.name, "an")), [2])
        XCTAssertEqual(assertPredicateParity(Contains(\Fixture.name, "AN")), [])
        XCTAssertEqual(assertPredicateParity(Contains(\Fixture.name, "AN", options: .caseInsensitive)), [2])
        XCTAssertEqual(
            Contains(\Fixture.name, "an", options: [.caseInsensitive, .diacriticInsensitive]).predicate.predicateFormat,
            "name CONTAINS[cd] \"an\""
        )
    }

    func testPrefixAndSuffix() {
        XCTAssertEqual(assertPredicateParity(HasPrefix(\Fixture.name, "Ap")), [1])
        XCTAssertEqual(assertPredicateParity(HasPrefix(\Fixture.name, "ap", options: .caseInsensitive)), [1, 4])
        XCTAssertEqual(assertPredicateParity(HasPrefix(\Fixture.name, "pple")), [])
        XCTAssertEqual(assertPredicateParity(HasSuffix(\Fixture.name, "ot")), [4, 5])
        XCTAssertEqual(assertPredicateParity(HasSuffix(\Fixture.name, "OT", options: .caseInsensitive)), [4, 5])
        XCTAssertEqual(assertPredicateParity(HasSuffix(\Fixture.name, "Carr")), [])
    }

    func testDiacriticInsensitivity() {
        XCTAssertEqual(assertPredicateParity(HasPrefix(\Fixture.name, "Cafe")), [])
        XCTAssertEqual(assertPredicateParity(HasPrefix(\Fixture.name, "Cafe", options: .diacriticInsensitive)), [3])
        XCTAssertEqual(assertPredicateParity(Contains(\Fixture.nickname, "mohre", options: [.caseInsensitive, .diacriticInsensitive])), [5])
    }

    func testNilNeverMatches() {
        XCTAssertEqual(assertPredicateParity(Contains(\Fixture.nickname, "e")), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(!Contains(\Fixture.nickname, "e")), [2, 4])
    }

    func testEmptyPattern() {
        assertPredicateParity(Contains(\Fixture.name, ""))
        assertPredicateParity(HasPrefix(\Fixture.name, ""))
        assertPredicateParity(HasSuffix(\Fixture.name, ""))
    }

}

final class StringPredicateSpellingTests: XCTestCase {

    func testInsideBuildersTheRootIsInferred() {
        let predicate = AnyOf(for: Fixture.self) {
            Contains(\.name, "an")
            HasSuffix(\.name, "ot")
        }
        XCTAssertEqual(assertPredicateParity(predicate), [2, 4, 5])
        XCTAssertEqual(predicate.predicate.predicateFormat, "name CONTAINS \"an\" OR name ENDSWITH \"ot\"")
    }

    func testMatchingStringsThemselves() {
        let words = ["apple", "Kiwi", "Avocado", "plum"]
        XCTAssertEqual(words.filterPredicate { Contains("a", options: .caseInsensitive) }, ["apple", "Avocado"])
        XCTAssertEqual(words.filter(by: HasPrefix("K")), ["Kiwi"])
        XCTAssertEqual(words.filter(by: !HasSuffix("o")), ["apple", "Kiwi", "plum"])
    }

    func testNotShadowedByAContainsMethod() {
        XCTAssertEqual(Catalog().matches("an"), [2])
    }

}

/// A type with its own `contains` method: a free `contains(_:_:)` function would be shadowed
/// here, but the `Contains` type is not.
private struct Catalog {
    func contains(_ id: Int) -> Bool {
        Fixture.all.contains { $0.id == id }
    }

    func matches(_ text: String) -> [Int] {
        Fixture.all.filter(by: Contains(\.name, text)).map(\.id)
    }
}
