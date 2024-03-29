// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(name: "Common", path: "../Common"),
        .package(name: "Domain", path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Common", "Domain"]),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"]),
    ]
)
