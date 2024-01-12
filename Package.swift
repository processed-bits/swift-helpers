// swift-tools-version: 5.8
import PackageDescription

let package = Package(
	name: "Swift Helpers",
	products: [
		.library(name: "Helpers", targets: ["Helpers"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
	],
	targets: [
		.target(name: "Helpers"),
		.testTarget(name: "HelpersTests", dependencies: ["Helpers"]),
	]
)
