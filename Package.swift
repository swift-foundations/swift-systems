// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-systems",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Systems",
            targets: ["Systems"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-primitives/swift-system-primitives"),
        .package(path: "../swift-darwin"),
        .package(path: "../swift-linux"),
        .package(path: "../swift-windows")
    ],
    targets: [
        .target(
            name: "Systems",
            dependencies: [
                .product(name: "System Primitives", package: "swift-system-primitives"),
                .product(name: "Darwin System", package: "swift-darwin", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux System", package: "swift-linux", condition: .when(platforms: [.linux])),
                .product(name: "Windows System", package: "swift-windows", condition: .when(platforms: [.windows]))
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
