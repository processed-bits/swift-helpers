// swift-tools-version: 5.9
// swiftlint:disable:previous file_name
import PackageDescription

var package = Package(
	name: "SwiftHelpers",
	products: [
		.library(name: "Helpers", targets: ["Helpers"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
	],
	targets: [
		.target(name: "Helpers", swiftSettings: [.bareSlashRegexLiterals]),
		.testTarget(name: "HelpersTests", dependencies: ["Helpers"], swiftSettings: [.bareSlashRegexLiterals]),
	]
)

extension SwiftSetting {
	static let bareSlashRegexLiterals: Self = .enableUpcomingFeature("BareSlashRegexLiterals")
	static let strictConcurrency: Self = .enableExperimentalFeature("StrictConcurrency")
}

#if compiler(<6)
	for package in package.targets {
		package.swiftSettings += [.strictConcurrency]
	}
#endif
