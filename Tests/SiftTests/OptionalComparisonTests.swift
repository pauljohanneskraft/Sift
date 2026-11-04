import XCTest
import Sift

final class OptionalComparisonTests: XCTestCase {

    let items = Item.all // ratings: 4, nil, 2, 5, nil

    func testOrderingAgainstValueTreatsNilAsFalse() {
        XCTAssertEqual(items.filter(by: \.rating < 4).stocks, [2])
        XCTAssertEqual(items.filter(by: \.rating <= 4).stocks, [0, 2])
        XCTAssertEqual(items.filter(by: \.rating > 2).stocks, [0, 3])
        XCTAssertEqual(items.filter(by: \.rating >= 2).stocks, [0, 2, 3])
        XCTAssertEqual(items.filter(by: !(\.rating < 4)).stocks, [0, 1, 3, 4])
    }

    func testValueOnTheLeft() {
        XCTAssertEqual(items.filter(by: 4 > \.rating).stocks, [2])
        XCTAssertEqual(items.filter(by: 4 >= \.rating).stocks, [0, 2])
        XCTAssertEqual(items.filter(by: 2 < \.rating).stocks, [0, 3])
        XCTAssertEqual(items.filter(by: 2 <= \.rating).stocks, [0, 2, 3])
    }

    func testTwoOptionalKeyPaths() {
        // (rating, previousRating): (4, 3), (nil, 2), (2, nil), (5, 5), (nil, nil)
        XCTAssertEqual(items.filter(by: \.rating > \.previousRating).stocks, [0])
        XCTAssertEqual(items.filter(by: \.rating >= \.previousRating).stocks, [0, 3])
        XCTAssertEqual(items.filter(by: \.rating < \.previousRating).stocks, [])
        XCTAssertEqual(items.filter(by: \.rating <= \.previousRating).stocks, [3])
    }

    func testEquality() {
        XCTAssertEqual(items.filter(by: \.rating == nil).stocks, [1, 4])
        XCTAssertEqual(items.filter(by: \.rating != nil).stocks, [0, 2, 3])
        XCTAssertEqual(items.filter(by: \.rating == 4).stocks, [0])
    }

}
