### 🧹 Sift

Sift is a Swift DSL for building **predicates** and **sort orders** from KeyPaths and result builders. You write the filter once, then evaluate it in memory or convert it into an `NSPredicate` and sort descriptors for Core Data and other Foundation APIs.

```swift
let affordable = items.filterPredicate {
    \.price < 5
    \.stock > 0
}

let sorted = items.sortedOrder {
    Descending(\.rating)
    \.price
}
```

### ✨ Features

- 🔍 **Readable predicates.** `\.price < 5 && \.stock > 0` instead of closures or format strings.
- 🧱 **Result builders.** `AllOf`, `AnyOf` and plain `if`/`else` for filters built at runtime.
- 🔀 **Composable orders.** `Ascending`, `Descending`, `Reverse`, `.then(_:)` and `OrderBuilder`.
- 🍎 **Foundation bridge.** The same values convert to `NSPredicate`, `NSSortDescriptor` and `SortDescriptor`.
- 🧪 **Type-checked.** Comparisons are checked against `Equatable` and `Comparable` at compile time.
- 📦 **No dependencies.** The core `Sift` module doesn't even import Foundation.

### 📥 Installation

Add Sift to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pauljohanneskraft/Sift", from: "1.0.0")
]
```

Then depend on one of the two products:

| Product | Use it for |
|---|---|
| `Sift` | Filtering and sorting Swift collections in memory. Pure Swift, no Foundation. |
| `SiftFoundation` | Everything in `Sift`, plus conversion to `NSPredicate`, `NSSortDescriptor` and `SortDescriptor`. |

### 📝 Usage

The examples use this type:

```swift
import Sift

struct Item {
    var name: String
    var price: Double
    var stock: Int
    var rating: Int?
}

let items = [
    Item(name: "Apple", price: 1.0, stock: 3, rating: 4),
    Item(name: "Orange", price: 1.5, stock: 0, rating: nil),
    Item(name: "Banana", price: 0.5, stock: 7, rating: 5),
]
```

#### 🔍 Predicates

Compare a keypath with a value or with another keypath, and combine predicates with `&&`, `||` and `!`:

```swift
let cheap = items.filter(by: \.price < 1.2)                  // Apple, Banana
let available = items.filter(by: \.stock > 0 && !(\.price > 1.2))
let either = items.filter(by: Xor(\.price < 1.2, \.stock == 0))
let named = items.filter(by: OneOf(\.name, ["Apple", "Kiwi"]))
```

`Xor` and `Nand` have no operators, so you construct them directly.

Ordering comparisons also work on optional properties; `nil` never matches:

```swift
let wellRated = items.filter(by: \.rating >= 4)              // Apple, Banana
let unrated = items.filter(by: \.rating == nil)              // Orange
```

#### 🧱 Predicate builders

`filterPredicate { }` joins its statements with AND. Nest `AnyOf { }` for OR and `AllOf { }` for AND. Use `if` and `if`/`else` to add conditions at runtime:

```swift
func search(_ text: String, inStockOnly: Bool) -> [Item] {
    items.filterPredicate {
        \.price < 2
        if !text.isEmpty {
            \.name == text
        }
        if inStockOnly {
            AnyOf {
                \.stock > 0
                \.rating == 5
            }
        }
    }
}
```

An `if` whose condition is false doesn't affect the result, whether it's inside `AllOf` or `AnyOf`. Outside a builder, give the root type explicitly: `AllOf(for: Item.self) { … }`.

#### 🔀 Sort orders

```swift
let byPrice = items.sorted(by: \.price)
let byPriceDescending = items.sorted(by: Descending(\.price))
let byStockThenPrice = items.sorted(by: Descending(\.stock).then(Ascending(\.price)))

let byStockDescendingThenName = items.sortedOrder {
    Reverse {
        \.stock
    }
    \.name
}
```

In `sortedOrder { }`, each statement breaks ties left by the ones before it. A bare keypath means `Ascending`.

#### 🍎 Foundation: `NSPredicate` and sort descriptors

`SiftFoundation` converts the same values into Foundation types. The conversion uses key-value coding, so the root type must be an `NSObject` subclass with `@objc` properties, which Core Data managed objects are:

```swift
import Foundation
import SiftFoundation

final class Product: NSObject {
    @objc var name: String
    @objc var price: Double
    @objc var category: String

    init(name: String, price: Double, category: String) {
        self.name = name
        self.price = price
        self.category = category
    }
}

let predicate = NSPredicate.build(for: Product.self) {
    \.price < 5
    AnyOf {
        \.category == "fruit"
        HasPrefix(\.name, "cafe", options: [.caseInsensitive, .diacriticInsensitive])
    }
}
// price < 5 AND (category == "fruit" OR name BEGINSWITH[cd] "cafe")

let nsSortDescriptors = [NSSortDescriptor].build(for: Product.self) {
    Descending(\.price)
    Ascending(\.name, comparator: .localizedStandard)
}

let sortDescriptors = [SortDescriptor<Product>].build {   // macOS 12 / iOS 15
    Descending(\.price)
}
```

Every predicate also has a `.predicate` property, and every order has `.nsSortDescriptors` and `.sortDescriptors`.

The string predicates `Contains`, `HasPrefix` and `HasSuffix` take `.caseInsensitive` and `.diacriticInsensitive` options, which map to `NSPredicate`'s `[c]` and `[d]` flags. They match the same way in memory, but in-memory evaluation needs `import SiftFoundation`. When the values you filter are strings themselves, leave out the keypath:

```swift
let words = ["apple", "Kiwi", "Avocado"].filterPredicate {
    Contains("a", options: .caseInsensitive)
}
// ["apple", "Avocado"]
```

Sort descriptors are available for keypaths to `Bool`, the integer types, `Double`, `Float`, `Date` and `UUID`, and their optionals. For `String`, use a comparator.

Every property in a converted keypath must be `@objc`. A stored `Int?` or `Double?` can't be `@objc`, so optional scalars only work through optional chaining, such as `\.parent?.rank`. Compared values must be of a type key-value coding can represent: the scalar types, `String`, `Date`, `Data`, `UUID`, `URL`, `NSObject` subclasses and their optionals. Other types, such as `Decimal`, don't compile; use `NSDecimalNumber`. An `@objc enum` works once you declare `extension MyEnum: NSPredicateUsableValue {}`, and is compared by raw value.

With `SiftFoundation` in your program, in-memory evaluation compares strings and floating-point values exactly as Foundation does, so `filter(by:)` and a Core Data fetch return the same objects, even for decomposed accents or `NaN`.

### 🧩 Extending Sift

Predicates and orders are plain values. Backends give them meaning through conditional conformances:
- in-memory evaluation: `SwiftEvaluablePredicate`, `SwiftEvaluableOrder`;
- Foundation conversion: `NSPredicateConvertible`, `SortDescriptorsConvertible`.

You can add a backend, for example one that generates SQL, without changing the DSL. The documentation catalog explains how.

### 📜 License

This project is licensed under the MIT License. See the LICENSE file for details.

### 🤝 Contributing

Contributions are welcome! Please open a pull request, or create an issue for a bug or feature request. Run `swift test` before submitting.
