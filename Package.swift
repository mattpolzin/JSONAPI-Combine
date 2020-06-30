// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONAPI-Combine",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "JSONAPICombine",
            targets: ["JSONAPICombine"]),
    ],
    dependencies: [
         .package(url: "https://github.com/mattpolzin/JSONAPI", from: "4.0.0"),
         .package(url: "https://github.com/mattpolzin/JSONAPI-ResourceStorage", .upToNextMinor(from: "0.2.2"))
    ],
    targets: [
        .target(
            name: "JSONAPICombine",
            dependencies: [
                "JSONAPI",
                .product(name: "JSONAPIResourceCache", package: "JSONAPI-ResourceStorage")]),
        .testTarget(
            name: "JSONAPICombineTests",
            dependencies: ["JSONAPICombine"]),
    ]
)
