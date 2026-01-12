// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-systems",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Systems",
            targets: ["Systems"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-system-primitives.git", from: "0.0.1"),
        .package(url: "https://github.com/swift-foundations/swift-darwin.git", from: "0.0.1"),
        .package(url: "https://github.com/swift-foundations/swift-linux.git", from: "0.0.1"),
        .package(url: "https://github.com/swift-foundations/swift-windows.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "Systems",
            dependencies: [
                .product(name: "System Primitives", package: "swift-system-primitives"),
                .product(name: "Darwin System", package: "swift-darwin", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux System", package: "swift-linux", condition: .when(platforms: [.linux])),
                .product(name: "Windows System", package: "swift-windows", condition: .when(platforms: [.windows])),
            ]
        ),
        .testTarget(
            name: "Systems Tests",
            dependencies: [
                "Systems",
            ],
            path: "Tests/Systems Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
