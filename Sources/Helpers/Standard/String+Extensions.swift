// String+Extensions.swift, 05.05.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

public extension String {

	// MARK: Quoted Filenames

	/// The default path quote character. The value is the apostrophe symbol `'`.
	static let defaultPathQuoteCharacter: Character = "'"

	/// Returns a quoted string if the string contains spaces. Otherwise, returns the original string.
	///
	///	This method is intended to be used with filenames or paths that need to be quoted for command-line interface.
	///
	/// - Parameters:
	///   - character: The quote character to use. Defaults to `String.defaultPathQuoteCharacter`.
	func quotedPath(character: Character = Self.defaultPathQuoteCharacter) -> Self {
		guard contains(" ") else {
			return self
		}
		let quote = String(character)
		return quote + self + quote
	}

}
