import XCTest
import Sift

// Many apps define their own keypath sort helper. Sift's `sorted(by:)` keypath overloads are
// disfavored, so they don't make such calls ambiguous. `private` keeps the helper out of the
// other test files.
private extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}

final class ClientHelperCompatibilityTests: XCTestCase {
    func testOwnKeyPathSortHelperIsNotAmbiguous() {
        XCTAssertEqual(Item.all.sorted(by: \.price).stocks, [2, 0, 1, 4, 3])
        // Sift's orders still work next to the helper.
        XCTAssertEqual(Item.all.sorted(by: Descending(\.price)).stocks, [3, 4, 1, 0, 2])
        XCTAssertEqual(Item.all.sorted(by: \.rating).prefix(2).stocks, [1, 4])
    }
}
