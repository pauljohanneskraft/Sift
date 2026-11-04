import Foundation

final class Fixture: NSObject {
    @objc let id: Int
    @objc let rank: Int
    @objc let double: Double
    @objc let bool: Bool
    @objc let name: String
    @objc let nickname: String?
    @objc let category: String
    @objc let date: Date
    @objc let deadline: Date?

    init(
        id: Int, rank: Int, double: Double, bool: Bool, name: String, nickname: String?,
        category: String, day: Double, deadlineDay: Double?
    ) {
        self.id = id
        self.rank = rank
        self.double = double
        self.bool = bool
        self.name = name
        self.nickname = nickname
        self.category = category
        self.date = Fixture.referenceDate.addingTimeInterval(day * 86_400)
        self.deadline = deadlineDay.map { Fixture.referenceDate.addingTimeInterval($0 * 86_400) }
    }

    override var description: String { "Fixture(\(id))" }

    static let referenceDate = Date(timeIntervalSince1970: 1_700_000_000)

    static func day(_ day: Double) -> Date {
        referenceDate.addingTimeInterval(day * 86_400)
    }

    static let all: [Fixture] = [
        Fixture(id: 1, rank: 3, double: 2.5, bool: true, name: "Apple", nickname: "apfel",
                category: "fruit", day: 1, deadlineDay: 3),
        Fixture(id: 2, rank: 2, double: 0.5, bool: false, name: "Banana", nickname: nil,
                category: "fruit", day: 5, deadlineDay: nil),
        Fixture(id: 3, rank: 3, double: 4.0, bool: true, name: "Café", nickname: "coffee",
                category: "drink", day: 2, deadlineDay: 1),
        Fixture(id: 4, rank: 1, double: 1.5, bool: false, name: "apricot", nickname: nil,
                category: "fruit", day: 4, deadlineDay: 6),
        Fixture(id: 5, rank: 5, double: 3.0, bool: true, name: "Carrot", nickname: "Möhre",
                category: "vegetable", day: 7, deadlineDay: nil),
    ]
}
