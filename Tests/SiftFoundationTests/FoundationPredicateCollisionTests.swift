import Foundation
import SiftFoundation
import XCTest

// Importing Foundation and SiftFoundation together must leave Foundation's `Predicate`
// unambiguous. This file only needs to compile.

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
private func usesFoundationPredicate(_ predicate: Predicate<Int>) -> Predicate<Int> {
    predicate
}

private func usesSiftPredicate<P: SiftPredicate>(_ predicate: P) -> P {
    predicate
}

final class FoundationPredicateCollisionTests: XCTestCase {
    func testBothPredicateTypesAreUsable() {
        _ = usesSiftPredicate(\Fixture.id == 1)
        if #available(macOS 14, iOS 17, tvOS 17, watchOS 10, *) {
            let predicate = usesFoundationPredicate(#Predicate<Int> { $0 > 1 })
            XCTAssertEqual(try predicate.evaluate(2), true)
        }
    }
}
