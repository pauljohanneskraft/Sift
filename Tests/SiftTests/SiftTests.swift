import XCTest
import Sift

final class SiftTests: XCTestCase {

    func testSorting() {
        let array = [1, 3, 7, 2]
        let result = array.filter(by: \.self < 5).sorted(by: Descending(\.self))
        XCTAssertEqual(result, [3, 2, 1])

        let a = [3, 1, 2].sorted(
            by: Reverse(Ascending(\.self))
                .then(Descending(\.self))
        )
        XCTAssertEqual(a, [3, 2, 1])

        let b = [3, 1, 2].sortedOrder {
            Reverse {
                \Int.self
            }
            Descending(\Int.self)
        }
        XCTAssertEqual(b, [3, 2, 1])
    }

}
