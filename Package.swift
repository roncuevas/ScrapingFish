// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScrapingFish",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ScrapingFish",
            targets: ["ScrapingFish"]),
    ],
    targets: [
        .target(
            name: "ScrapingFish",
            path: "ScrapingFish/Sources"),
        .testTarget(name: "ScrapingFishTests",
                    dependencies: ["ScrapingFish"],
                    path: "ScrapingFish/Tests"),
    ]
)
