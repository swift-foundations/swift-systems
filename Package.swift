// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-systems",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Systems",
            targets: ["Systems"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-system.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-compositions/swift-kernel.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-darwin.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-linux.git", branch: "main"),
        .package(url: "https://github.com/swift-microsoft/swift-windows-32.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-test-application.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Systems",
            dependencies: [
                .product(name: "System", package: "swift-system"),
                .product(name: "Kernel", package: "swift-kernel"),
                .product(
                    name: "Darwin System",
                    package: "swift-darwin",
                    condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])
                ),
                .product(
                    name: "Linux System",
                    package: "swift-linux",
                    condition: .when(platforms: [.linux])
                ),
                .product(
                    name: "Windows 32 Kernel System",
                    package: "swift-windows-32",
                    condition: .when(platforms: [.windows])
                ),


            ]
        ),
        .testTarget(
            name: "Systems Tests",
            dependencies: [
                "Systems",
                .product(name: "Kernel System", package: "swift-kernel"),
                .product(name: "System", package: "swift-system"),
                .product(name: "Testing", package: "swift-test-application"),
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
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
