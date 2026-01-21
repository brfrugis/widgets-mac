// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WorldClock",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "WorldClock",
            targets: ["WorldClock"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "WorldClock",
            dependencies: [],
            path: "Sources/WorldClock",
            exclude: ["Info.plist"]
        )
    ]
)
