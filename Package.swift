// swift-tools-version: 6.3.1

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
        .package(path: "../swift-kernel"),
        .package(path: "../swift-darwin"),
        .package(path: "../swift-linux"),
        .package(path: "../../swift-microsoft/swift-windows-32")
    ],
    targets: [
        .target(
            name: "Systems",
            dependencies: [
                .product(name: "System Primitives", package: "swift-system-primitives"),
                .product(name: "Kernel", package: "swift-kernel"),
                .product(name: "Darwin System", package: "swift-darwin", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux System", package: "swift-linux", condition: .when(platforms: [.linux])),
                .product(name: "Windows 32 Kernel System", package: "swift-windows-32", condition: .when(platforms: [.windows]))
            ]
        ),
        .testTarget(
            name: "Systems Tests",
            dependencies: [
                "Systems",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
