// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "Storage",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "Storage",
      targets: ["Storage"]
    )
  ],
  dependencies: [
    .package(
      name: "Unwrap",
      url:
      "https://github.com/neutralradiance/swift-unwrap.git",
      .branch("main")
    ),
    .package(
      url:
      "https://github.com/apple/swift-algorithms.git",
      .branch("main")
    )
  ],
  targets: [
    .target(
      name: "Storage",
      dependencies: [
        "Unwrap",
        .product(name: "Algorithms", package: "swift-algorithms")
      ]
    ),
    .testTarget(
      name: "StorageTests",
      dependencies: ["Storage", "Unwrap"]
    )
  ]
)
