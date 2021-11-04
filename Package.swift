// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "json5tojson",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "json5tojson", targets: ["json5tojson"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "json5tojson",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
    ]
)
