// swift-tools-version: 6.0
// swiftlint:disable:previous file_name

// Package.swift, 16.05.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import PackageDescription

var package = Package(
	name: "SwiftHelpers",
	products: [
		.library(name: "AppKitHelpers", targets: ["AppKitHelpers"]),
		.library(name: "CoreAnimationHelpers", targets: ["CoreAnimationHelpers"]),
		.library(name: "CoreDataHelpers", targets: ["CoreDataHelpers"]),
		.library(name: "CoreGraphicsHelpers", targets: ["CoreGraphicsHelpers"]),
		.library(name: "DebuggingHelpers", targets: ["DebuggingHelpers"]),
		.library(name: "ExitCodeHelpers", targets: ["ExitCodeHelpers"]),
		.library(name: "FoundationHelpers", targets: ["FoundationHelpers"]),
		.library(name: "FoundationLegacyHelpers", targets: ["FoundationLegacyHelpers"]),
		.library(name: "LoggingHelpers", targets: ["LoggingHelpers"]),
		.library(name: "OutputHelpers", targets: ["OutputHelpers"]),
		.library(name: "StandardLibraryHelpers", targets: ["StandardLibraryHelpers"]),
		.library(name: "SynchronizationHelpers", targets: ["SynchronizationHelpers"]),
	],
	targets: [
		// Libraries targets.
		.target(name: "AppKitHelpers", dependencies: ["FoundationHelpers"]),
		.target(name: "CoreAnimationHelpers"),
		.target(name: "CoreDataHelpers"),
		.target(name: "CoreGraphicsHelpers", dependencies: ["FoundationHelpers"]),
		.target(name: "DebuggingHelpers", dependencies: ["SynchronizationHelpers"]),
		.target(name: "ExitCodeHelpers"),
		.target(name: "FoundationHelpers", dependencies: ["StandardLibraryHelpers"]),
		.target(name: "FoundationLegacyHelpers"),
		.target(name: "LoggingHelpers"),
		.target(name: "OutputHelpers", dependencies: ["SynchronizationHelpers"]),
		.target(name: "StandardLibraryHelpers"),
		.target(name: "SynchronizationHelpers"),

		// Internal target.
		.target(name: "TestingShared"),

		// Tests targets.
		.testTarget(
			name: "AppKitHelpersTests",
			dependencies: ["AppKitHelpers"]
		),
		.testTarget(
			name: "CoreGraphicsHelpersTests",
			dependencies: ["CoreGraphicsHelpers"]
		),
		.testTarget(
			name: "DebuggingHelpersTests",
			dependencies: ["DebuggingHelpers", "StandardLibraryHelpers", .testingShared]
		),
		.testTarget(
			name: "FoundationHelpersTests",
			dependencies: ["DebuggingHelpers", "FoundationHelpers", .testingShared]
		),
		.testTarget(
			name: "FoundationLegacyHelpersTests",
			dependencies: ["FoundationLegacyHelpers"]
		),
		.testTarget(
			name: "LoggingHelpersTests",
			dependencies: ["LoggingHelpers"]
		),
		.testTarget(
			name: "OutputHelpersTests",
			dependencies: ["FoundationHelpers", "OutputHelpers"]
		),
		.testTarget(
			name: "StandardLibraryHelpersTests",
			dependencies: ["StandardLibraryHelpers"]
		),
		.testTarget(
			name: "SynchronizationHelpersTests",
			dependencies: ["DebuggingHelpers", "StandardLibraryHelpers", "SynchronizationHelpers", .testingShared]
		),
	]
)

extension Target.Dependency {
	static var testingShared: Self { .target(name: "TestingShared") }
}

extension SwiftSetting {
	static var memberImportVisibility: Self { .enableUpcomingFeature("MemberImportVisibility") }
}

for target in package.targets {
	target.swiftSettings = [.memberImportVisibility]
}
