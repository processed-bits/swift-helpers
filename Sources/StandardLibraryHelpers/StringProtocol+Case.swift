// StringProtocol+Case.swift, 19.08.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation

public extension StringProtocol {

	// MARK: Changing Case

	/// Returns a version of the string with the first letter converted to lowercase.
	var lowercasedFirstLetter: String {
		prefix(1).lowercased() + dropFirst()
	}

	/// Returns a version of the string with the first letter converted to lowercase, taking into account the specified locale.
	func lowercasedFirstLetter(with locale: Locale?) -> String {
		prefix(1).lowercased(with: locale) + dropFirst()
	}

	/// A version of the string with the first letter converted to lowercase that is produced using the current locale.
	@available(iOS 9.0, macOS 10.11, watchOS 2.0, *)
	var localizedLowercasedFirstLetter: String {
		prefix(1).localizedLowercase + dropFirst()
	}

	/// Returns a version of the string with the first letter converted to uppercase.
	var uppercasedFirstLetter: String {
		prefix(1).uppercased() + dropFirst()
	}

	/// Returns a version of the string with the first letter converted to uppercase, taking into account the specified locale.
	func uppercasedFirstLetter(with locale: Locale?) -> String {
		prefix(1).uppercased(with: locale) + dropFirst()
	}

	/// A version of the string with the first letter converted to uppercase that is produced using the current locale.
	@available(iOS 9.0, macOS 10.11, watchOS 2.0, *)
	var localizedUppercasedFirstLetter: String {
		prefix(1).localizedUppercase + dropFirst()
	}

}
