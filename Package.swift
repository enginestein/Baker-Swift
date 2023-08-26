// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LIBRARY-NAME",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "LIBRARY-NAME",
            targets: ["LIBRARY-NAME"]
        ),
        .library(
            name: "LIBRARY-NAMEDynamic",
            type: .dynamic,
            targets: ["LIBRARY-NAME"]
        )
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0")
    ],
    targets: [
        .target(
            name: "LIBRARY-NAME",
            dependencies: []
        ),
        .testTarget(
            name: "LIBRARY-NAMETests",
            dependencies: ["LIBRARY-NAME"]
        )
    ]
)
