// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Notifications",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .macOS(.v13),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "Notifications",
            targets: ["Notifications"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.5.4"),
        .package(
            url: "https://github.com/tonyfreeman/firebase-ios-sdk",
            from: "11.6.0-messaging")
    ],
    targets: [
        .target(
            name: "Notifications",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "NotificationsTests",
            dependencies: ["Notifications"],
            path: "Tests")
    ]
)
