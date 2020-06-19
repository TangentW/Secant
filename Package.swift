// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Secant",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "Secant", targets: ["Secant"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Secant", dependencies: [], path: "Sources"),
        .testTarget(name: "SecantTests", dependencies: ["Secant"]),
    ],
    swiftLanguageVersions: [.v5]
)
