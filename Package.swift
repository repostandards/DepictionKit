// swift-tools-version:5.4

import PackageDescription

let package = Package(
	name: "DepictionKit",
	platforms: [
		.iOS(.v12)
	],
	products: [
		.library(name: "DepictionKit", targets: ["DepictionKit"]),
	],
	targets: [
		.target(name: "DepictionKit", path: "DepictionKit")
	]
)
