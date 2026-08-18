// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-systems",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27")
    ],
    products: [
        .library(
            name: "Systems",
            targets: ["Systems"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-system-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-kernel.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-darwin.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-linux.git", branch: "main"),
        .package(url: "https://github.com/swift-microsoft/swift-windows-32.git", branch: "main")
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
                .product(name: "Kernel System", package: "swift-kernel"),
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
