// Bundle+Extensions.swift, 05.12.2019-05.05.2023.
// Copyright © 2019-2023 Stanislav Lomachinskiy.

import Foundation

/// Bundle information helpers.
public extension Bundle {

	// MARK: Getting Bundle Information

	/// The receiver’s bundle name.
	///
	/// The bundle name is defined by the `CFBundleName` key in the bundle’s information property list.
	var bundleName: String? {
		object(forInfoDictionaryKey: "CFBundleName") as? String
	}

	/// The receiver’s bundle display name.
	///
	/// The bundle display name is defined by the `CFBundleDisplayName` key in the bundle’s information property list.
	var bundleDisplayName: String? {
		object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
	}

	/// The receiver’s bundle short version string.
	///
	/// The bundle short version string is defined by the `CFBundleShortVersionString` key in the bundle’s information property list.
	var bundleShortVersionString: String? {
		object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}

	/// The receiver’s bundle version.
	///
	/// The bundle version is defined by the `CFBundleVersion` key in the bundle’s information property list.
	var bundleVersion: Int? {
		Int(object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")
	}

	/// The receiver’s combined version string.
	///
	/// The combined version string is defined by the `CFBundleShortVersionString` and `CFBundleVersion` keys in the bundle’s information property list.
	var combinedVersionString: String? {
		guard var string = bundleShortVersionString else {
			return nil
		}
		if let bundleVersion {
			string += " (\(bundleVersion))"
		}
		return string
	}

	/// The receiver's executable filename.
	///
	/// The executable filename is defined by the `CFBundleExecutable` key in the bundle’s information property list.
	var executableFile: String? {
		object(forInfoDictionaryKey: "CFBundleExecutable") as? String
	}

	/// The receiver's quoted executable filename.
	///
	/// If the filename contains spaces, resulting filename is quoted. The executable filename is defined by the `CFBundleExecutable` key in the bundle’s information property list.
	///
	/// - Parameters:
	///   - character: The quote character to use. Defaults to `String.defaultPathQuoteCharacter`.
	func quotedExecutableFile(character: Character = String.defaultPathQuoteCharacter) -> String? {
		executableFile?.quotedPath(character: character)
	}

	/// The receiver’s human readable copyright.
	///
	/// The human readable copyright is defined by the `NSHumanReadableCopyright` key in the bundle’s information property list.
	var humanReadableCopyright: String? {
		object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
	}

}
