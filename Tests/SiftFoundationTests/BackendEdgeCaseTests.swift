import Foundation
import SiftFoundation
import XCTest

// Regression tests for cases where the in-memory and Foundation backends used to disagree.

@objc enum Color: Int, NSPredicateUsableValue {
    case red, green, blue
}

final class Record: NSObject, ParityRecord {
    @objc let id: Int
    @objc let text: String
    @objc let optionalText: String?
    @objc let name: String
    @objc let label: String
    @objc let start: Date?
    @objc let end: Date?
    @objc let color: Color
    @objc let float: Float
    @objc let double: Double
    @objc let int8: Int8
    @objc let int16: Int16
    @objc let int32: Int32
    @objc let int64: Int64
    @objc let uint: UInt
    @objc let uint8: UInt8
    @objc let uint16: UInt16
    @objc let uint32: UInt32
    @objc let uint64: UInt64
    @objc let uuid: UUID
    @objc let optionalUUID: UUID?
    @objc var parent: Record?

    init(
        id: Int, text: String, optionalText: String?, name: String, label: String,
        startDay: Double?, endDay: Double?, color: Color, number: Int, double: Double, uuid: String, optionalUUID: String?
    ) {
        self.id = id
        self.text = text
        self.optionalText = optionalText
        self.name = name
        self.label = label
        self.start = startDay.map(Fixture.day)
        self.end = endDay.map(Fixture.day)
        self.color = color
        self.float = Float(number) / 2
        self.double = double
        self.int8 = Int8(number)
        self.int16 = Int16(number) * 100
        self.int32 = Int32(number) * 10_000
        self.int64 = Int64(number) * 1_000_000_000
        self.uint = UInt(number)
        self.uint8 = UInt8(number)
        self.uint16 = UInt16(number)
        self.uint32 = UInt32(number)
        self.uint64 = UInt64(number)
        self.uuid = UUID(uuidString: uuid)!
        self.optionalUUID = optionalUUID.map { UUID(uuidString: $0)! }
    }

    override var description: String { "Record(\(id))" }

    static let all: [Record] = {
        let records = [
            Record(id: 1, text: "line1\r\nline2", optionalText: "x", name: "b", label: "Zed",
                   startDay: 1, endDay: 2, color: .red, number: 4, double: 1.0,
                   uuid: "00000000-0000-0000-0000-000000000003", optionalUUID: "00000000-0000-0000-0000-000000000002"),
            Record(id: 2, text: "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}", optionalText: nil, name: "a", label: "\u{C9}mile",
                   startDay: nil, endDay: nil, color: .green, number: 2, double: .nan,
                   uuid: "00000000-0000-0000-0000-000000000005", optionalUUID: nil),
            Record(id: 3, text: "\u{1F1E9}\u{1F1EA}\u{1F1EB}\u{1F1F7}", optionalText: "y", name: "C", label: "f",
                   startDay: 3, endDay: 1, color: .blue, number: 5, double: 3.0,
                   uuid: "00000000-0000-0000-0000-000000000001", optionalUUID: "00000000-0000-0000-0000-000000000001"),
            Record(id: 4, text: "Cafe\u{301}", optionalText: nil, name: "a2", label: "apple",
                   startDay: nil, endDay: 2, color: .red, number: 1, double: -1.0,
                   uuid: "00000000-0000-0000-0000-000000000004", optionalUUID: nil),
            Record(id: 5, text: "plain", optionalText: "x", name: "a10", label: "Apple",
                   startDay: 2, endDay: 2, color: .green, number: 3, double: 2.0,
                   uuid: "00000000-0000-0000-0000-000000000002", optionalUUID: "00000000-0000-0000-0000-000000000003"),
        ]
        // parent ids: 1 → 3, 2 → nil, 3 → 1, 4 → 5, 5 → nil
        records[0].parent = records[2]
        records[2].parent = records[0]
        records[3].parent = records[4]
        return records
    }()
}

/// A client-defined operator with its own `NSPredicate` conversion.
enum CaseInsensitiveEqualOperator: SwiftEvaluablePredicateValueOperator, NSPredicateConvertibleValueOperator {
    typealias Value = String

    static func compare(_ first: String, with second: String) -> Bool {
        first.caseInsensitiveCompare(second) == .orderedSame
    }

    static func predicate<Root: NSObject>(
        for keyPath0: KeyPath<Root, String>,
        and keyPath1: KeyPath<Root, String>
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath0),
            rightExpression: NSExpression(forKeyPath: keyPath1),
            modifier: .direct,
            type: .equalTo,
            options: .caseInsensitive
        )
    }

    static func predicate<Root: NSObject>(
        for keyPath: KeyPath<Root, String>,
        and value: String
    ) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: value),
            modifier: .direct,
            type: .equalTo,
            options: .caseInsensitive
        )
    }
}

final class BackendEdgeCaseTests: XCTestCase {
    let records = Record.all

    func testStringMatchingInsideGraphemeClusters() {
        XCTAssertEqual(assertPredicateParity(Contains(\Record.text, "\n"), in: records), [1])
        XCTAssertEqual(assertPredicateParity(Contains(\Record.text, "\r", options: .caseInsensitive), in: records), [1])
        XCTAssertEqual(assertPredicateParity(HasPrefix(\Record.text, "line1\r"), in: records), [1])
        XCTAssertEqual(assertPredicateParity(Contains(\Record.text, "\u{1F469}"), in: records), [2])
        XCTAssertEqual(assertPredicateParity(Contains(\Record.text, "\u{1F1EA}\u{1F1EB}"), in: records), [3])
        XCTAssertEqual(assertPredicateParity(HasSuffix(\Record.text, "\u{301}"), in: records), [4])
        XCTAssertEqual(assertPredicateParity(HasSuffix(\Record.text, "line2"), in: records), [1])
    }

    func testOptionalKeyPathComparisonsWithNil() {
        // (start, end) in days: (1, 2), (nil, nil), (3, 1), (nil, 2), (2, 2)
        XCTAssertEqual(assertPredicateParity(\Record.start <= \Record.end, in: records), [1, 5])
        XCTAssertEqual(assertPredicateParity(\Record.start >= \Record.end, in: records), [3, 5])
        XCTAssertEqual(assertPredicateParity(\Record.start < \Record.end, in: records), [1])
        XCTAssertEqual(assertPredicateParity(\Record.start > \Record.end, in: records), [3])
        XCTAssertEqual(assertPredicateParity(!(\Record.start <= \Record.end), in: records), [2, 3, 4])
        XCTAssertEqual(assertPredicateParity(\Record.start <= \Record.start, in: records), [1, 3, 5])
        XCTAssertEqual(assertPredicateParity(\Record.start < Fixture.day(3), in: records), [1, 5])
        XCTAssertEqual(assertPredicateParity(!(\Record.start < Fixture.day(3)), in: records), [2, 3, 4])
    }

    func testMembershipWithNil() {
        // optionalText: "x", nil, "y", nil, "x"
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.optionalText, [nil, "x"]), in: records), [1, 2, 4, 5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.optionalText, ["y"]), in: records), [3])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.optionalText, [nil]), in: records), [2, 4])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.start, [nil]), in: records), [2, 4])
        XCTAssertEqual(assertPredicateParity(!OneOf(\Record.optionalText, [nil]), in: records), [1, 3, 5])
    }

    func testObjCEnumConstants() {
        // colors: red, green, blue, red, green
        XCTAssertEqual((\Record.color == .red).predicate.predicateFormat, "color == 0")
        XCTAssertEqual(assertPredicateParity(\Record.color == .red, in: records), [1, 4])
        XCTAssertEqual(assertPredicateParity(\Record.color != .red, in: records), [2, 3, 5])
        XCTAssertEqual(assertPredicateParity(OneOf(\Record.color, [.red, .green]), in: records), [1, 2, 4, 5])
    }

    func testCustomValueOperatorConversionIsUsed() {
        let predicate = KeyPathValuePredicateValue<Record, CaseInsensitiveEqualOperator>(keyPath: \.text, value: "PLAIN")
        XCTAssertEqual(predicate.predicate.predicateFormat, "text ==[c] \"PLAIN\"")
        XCTAssertEqual(assertPredicateParity(predicate, in: records), [5])
        let keyPaths = KeyPathKeyPathPredicateValue<Record, CaseInsensitiveEqualOperator>(\.name, \.label)
        XCTAssertEqual(keyPaths.predicate.predicateFormat, "name ==[c] label")
    }

    func testOptionalChainedKeyPaths() {
        // parent ids: 3, nil, 1, 5, nil
        XCTAssertEqual((\Record.parent?.id > 2).predicate.predicateFormat, "parent.id > 2")
        XCTAssertEqual(assertPredicateParity(\Record.parent?.id > 2, in: records), [1, 4])
        XCTAssertEqual(assertPredicateParity(\Record.parent?.id == nil, in: records), [2, 5])
    }

    func testStringComparatorOrders() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        // names: b, a, C, a2, a10
        let reversed = String.StandardComparator(.localizedStandard, order: .reverse)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.name, comparator: reversed), in: records), [3, 1, 5, 4, 2])
        XCTAssertEqual(assertOrderParity(Descending(\Record.name, comparator: reversed), in: records), [2, 4, 5, 1, 3])
        XCTAssertEqual(assertOrderParity(Ascending(\Record.name, comparator: .localizedStandard), in: records), [2, 4, 5, 1, 3])
        // labels: Zed, Émile, f, apple, Apple. Foundation sorts .lexical with NSString.compare(_:), which puts
        // "Émile" next to "E"; Swift's own lexical order would put it after "f".
        XCTAssertEqual(assertOrderParity(Ascending(\Record.label, comparator: .lexical), in: records), [5, 2, 1, 4, 3])
        XCTAssertEqual(assertOrderParity(Descending(\Record.label, comparator: .lexical), in: records), [3, 4, 1, 2, 5])
        // A reversed comparator also moves nil to the end, as in Foundation.
        let optional = Ascending(\Record.optionalText, comparator: reversed).then(Ascending(\.id))
        XCTAssertEqual(assertOrderParity(optional, in: records), [3, 1, 5, 2, 4])
    }

    func testNewlySortableValueTypes() throws {
        try requireSortDescriptors()
        guard #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) else { return }
        // numbers: 4, 2, 5, 1, 3
        let byNumber = [4, 2, 5, 1, 3]
        XCTAssertEqual(assertOrderParity(Ascending(\Record.float), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.int8), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.int16), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.int32), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.int64), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.uint), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.uint8), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.uint16), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Ascending(\Record.uint32), in: records), byNumber)
        XCTAssertEqual(assertOrderParity(Descending(\Record.uint64), in: records), byNumber.reversed())
        // start days: 1, nil, 3, nil, 2. nil sorts first.
        XCTAssertEqual(assertOrderParity(Ascending(\Record.start).then(Ascending(\.id)), in: records), [2, 4, 1, 5, 3])
        XCTAssertEqual(assertOrderParity(Descending(\Record.start).then(Ascending(\.id)), in: records), [3, 5, 1, 2, 4])
        // parent ids: 3, nil, 1, 5, nil
        XCTAssertEqual(assertOrderParity(Ascending(\Record.parent?.id).then(Ascending(\.id)), in: records), [2, 5, 3, 1, 4])
    }

    func testUUIDOrders() throws {
        try requireSortDescriptors()
        guard #available(macOS 14, iOS 17, tvOS 17, watchOS 10, *) else {
            throw XCTSkip("UUID is Comparable from macOS 14 / iOS 17")
        }
        // uuid suffixes: 3, 5, 1, 4, 2; optionalUUID suffixes: 2, nil, 1, nil, 3
        XCTAssertEqual(assertOrderParity(Ascending(\Record.uuid), in: records), [3, 5, 1, 4, 2])
        XCTAssertEqual(assertOrderParity(Ascending(\Record.optionalUUID).then(Ascending(\.id)), in: records), [2, 4, 3, 1, 5])
    }
}
