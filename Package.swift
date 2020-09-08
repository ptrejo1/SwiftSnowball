// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSnowball",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftSnowball",
            targets: ["SwiftSnowball"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", .exact("0.5.6"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftSnowball",
            dependencies: []),
        .testTarget(
            name: "SwiftSnowballTests",
            dependencies: ["SwiftSnowball", "SwiftCSV"]),
    ],
    swiftLanguageVersions: [.v5]
)
