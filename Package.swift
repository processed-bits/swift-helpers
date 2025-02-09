// swift-tools-version: 5.8
import PackageDescription

let package = Package(
	name: "swift-helpers",
	products: [
		.library(name: "Helpers", targets: ["Helpers"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
	],
	targets: [
		.target(
			name: "Helpers",
			swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]
		),
		.testTarget(
			name: "HelpersTests",
			dependencies: ["Helpers"]
		),
	],
	swiftLanguageVersions: [.version("6"), .v5]
)
