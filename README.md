### 🧹 Sift

Sift is a Swift Domain-Specific Language (DSL) that provides a clean, readable way to construct predicates and sort orders using KeyPaths and Result Builders. Designed for Swift developers, Sift simplifies complex filtering and sorting logic, making it easy to integrate powerful data manipulation in your projects.

### ✨ Features

	•	🔍 Concise Predicate and Sort Descriptions: Easily define predicates and sort orders without verbose syntax.
	•	🛠️ Swift KeyPath Support: Leverages Swift KeyPaths to access properties directly, making code safe and expressive.
	•	🚀 Result Builder Integration: Combines the power of Swift’s Result Builders to enable a readable DSL.
	•	📦 Easy Integration: Available as a Swift Package for seamless integration.

### 📥 Installation

To integrate Sift into your Swift project, add it as a dependency in your Package.swift file:
```
dependencies: [
    .package(url: "https://github.com/pauljohanneskraft/Sift", from: "1.0.0")
]
```

### 📝 Usage

🔧 Basic Predicate and Sort Order Creation

With Sift, you can create predicates and sort descriptors concisely:
```swift 
import Sift

struct Item {
    var name: String
    var price: Double
}

let items = [
    Item(name: "Apple", price: 1.0),
    Item(name: "Orange", price: 1.5),
    Item(name: "Banana", price: 0.5)
]

// Applying the filter
let filteredItems = items.filter(by: \.price < 5)

// Defining a sort order
let sortedItems = items.sorted(by: Descending(\.self))
```

### 🔄 Advanced Compositions

Combine multiple conditions for complex filters and sort orders:
```swift

let sortedComplexItems = items.sortedOrder {
        Reverse {
            \Int.self
        }
        Descending(\Int.self)
    }
```
### 📚 Documentation

Further documentation, examples, and advanced usage guides are not yet available.

### 📜 License

This project is licensed under the MIT License. See the LICENSE file for more details.

### 🤝 Contributing

Contributions are welcome! Please submit a pull request or create an issue for any bugs or feature requests.