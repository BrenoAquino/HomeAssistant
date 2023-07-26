// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Features",
            targets: ["Core", "Dashboard", "DashboardCreation", "Config"]),
    ],
    dependencies: [
        .package(name: "Common", path: "../Common"),
        .package(name: "Domain", path: "../Domain"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: ["Common", "Domain"]),
        .target(
            name: "Core",
            dependencies: ["Common", "DesignSystem", "Preview", "Domain"],
            resources: [.process("Resources")]),
        .target(
            name: "Dashboard",
            dependencies: ["Common", "DesignSystem", "Preview", "Domain"],
            resources: [.process("Resources")]),
        .target(
            name: "DashboardCreation",
            dependencies: ["Common", "DesignSystem", "Preview", "Domain"],
            resources: [.process("Resources")]),
        .target(
            name: "Config",
            dependencies: ["Common", "DesignSystem", "Preview", "Domain"],
            resources: [.process("Resources")]),
        .target(
            name: "Preview",
            dependencies: ["Common", "Domain"]),
    ]
)
