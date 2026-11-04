import Foundation
import SiftFoundation
import XCTest

/// Asserts that in-memory evaluation and `NSPredicate` evaluation select the same fixtures,
/// and returns the selected ids.
@discardableResult
func assertPredicateParity<P: SwiftEvaluablePredicate & NSPredicateConvertible>(
    _ predicate: P,
    on fixtures: [Fixture] = Fixture.all,
    file: StaticString = #filePath,
    line: UInt = #line
) -> [Int] where P.Root == Fixture {
    let nsPredicate = predicate.predicate
    let swift = fixtures.filter { predicate.evaluate(on: $0) }.map(\.id)
    let foundation = fixtures.filter { nsPredicate.evaluate(with: $0) }.map(\.id)
    XCTAssertEqual(swift, foundation, "Backends disagree on \(nsPredicate)", file: file, line: line)
    return swift
}

/// Asserts that Swift sorting, `SortDescriptor` sorting and `NSSortDescriptor` sorting all
/// produce the same order, and returns the sorted ids.
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
@discardableResult
func assertOrderParity<O: SwiftEvaluableOrder & SortDescriptorsConvertible>(
    _ order: O,
    on fixtures: [Fixture] = Fixture.all,
    file: StaticString = #filePath,
    line: UInt = #line
) -> [Int] where O.Root == Fixture {
    let swift = fixtures.sorted(by: order).map(\.id)
    let foundation = fixtures.sorted(using: order.sortDescriptors).map(\.id)
    let nsFoundation = (fixtures as NSArray)
        .sortedArray(using: order.nsSortDescriptors)
        .map { ($0 as! Fixture).id }
    XCTAssertEqual(swift, foundation, "Swift and SortDescriptor disagree", file: file, line: line)
    XCTAssertEqual(swift, nsFoundation, "Swift and NSSortDescriptor disagree", file: file, line: line)
    return swift
}

func requireSortDescriptors() throws {
    guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else {
        throw XCTSkip("SortDescriptor requires macOS 12 / iOS 15")
    }
}
