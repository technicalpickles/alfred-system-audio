// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "systemaudio",
    platforms: [
        .macOS(.v10_12)
    ],
    dependencies: [
        // .package(url: "https://github.com/rnine/SimplyCoreAudio.git", from: "4.0.1"),
        .package(url: "https://github.com/technicalpickles/SimplyCoreAudio", .branch("4.0.1-fixed")),
        // .package(url: "../SimplyCoreAudio", .branch("4.0.1-fixed")),

        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))


    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "systemaudio",
            dependencies: [
                "SimplyCoreAudio",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Rainbow",
            ]),
        .testTarget(
            name: "systemaudioTests",
            dependencies: ["systemaudio"]),
    ]
)
