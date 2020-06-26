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
        .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.1.5"),
    ],
    targets: [
        .target(name: "Secant", dependencies: ["DifferenceKit"], path: "Sources"),
        .testTarget(name: "SecantTests", dependencies: ["Secant"]),
    ],
    swiftLanguageVersions: [.v5]
)
