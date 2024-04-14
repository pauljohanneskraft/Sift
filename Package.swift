// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Sift",
    products: [
        .library(
            name: "Sift",
            targets: ["Sift"]),
        .library(
            name: "SiftFoundation",
            targets: ["Sift", "SiftFoundation"]),
    ],
    targets: [
        .target(
            name: "Sift",
            dependencies: []),
        .target(
            name: "SiftFoundation",
            dependencies: ["Sift"]),
        .testTarget(
            name: "SiftTests",
            dependencies: ["Sift"]),
        .testTarget(
            name: "SiftFoundationTests",
            dependencies: ["SiftFoundation"]),
    ]
)
