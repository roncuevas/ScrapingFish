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
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ScrapingFish",
            dependencies: ["Alamofire"],
            path: "ScrapingFish/Sources"),
        .testTarget(name: "ScrapingFishTests",
                    dependencies: ["ScrapingFish"],
                    path: "ScrapingFish/Tests"),
    ]
)
