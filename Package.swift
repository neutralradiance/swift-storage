// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Storage",
            targets: ["Storage"])
    ],
    dependencies: [
         .package(url: "https://github.com/neutralradiance/swift-unwrap.git", .branch("master")),
                  .package(url: "https://github.com/apple/swift-algorithms.git", .branch("master"))
         
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Storage",
            dependencies: [
            "Unwrap",
            .product(name: "Algorithms", package: "swift-algorithms")
            ]),
        .testTarget(
            name: "StorageTests",
            dependencies: ["Storage", "Unwrap"])
    ]
)
