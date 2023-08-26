// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Baker",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Baker",
            targets: ["Baker"]
        ),
        .library(
            name: "BakerDynamic",
            type: .dynamic,
            targets: ["Baker"]
        )
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Baker",
            dependencies: []
        ),
        .testTarget(
            name: "BakerTests",
            dependencies: ["Baker"]
        )
    ]
)
