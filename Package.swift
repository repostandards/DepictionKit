// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DepictionKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "DepictionKit",
                 targets: ["DepictionKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnxnguyen/Down.git",
                 from: "0.11.0")
    ],
    targets: [
        .target(name: "DepictionKit",
                dependencies: ["Down"],
                path: "DepictionKit",
                exclude: ["Info.plist"])
    ]
)
