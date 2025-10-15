// String+Truncation.swift, 20.11.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation

public extension String {

	// MARK: Truncating

	/// The default truncation terminator string. The value is the ellipsis symbol (`…` or `\u{2026}`).
	static let defaultTruncationTerminator = "…"

	/// Returns a truncated string, up to the specified maximum length, which includes the termination string.
	///
	/// If the maximum length exceeds the string length, the result contains unchanged string.
	///
	/// If the maximum length is less than the termination string length, the string is truncated without a termination string.
	///
	/// - Parameters:
	///   - maxLength: The maximum length of string to return. `maxLength` must be greater than or equal to zero.
	///   - terminator: The termination string. Defaults to ``String/defaultTruncationTerminator``.
	///   - removeCharacters: Unwanted characters to remove right before the termination string. Defaults to removing non-alphanumeric characters (spaces, punctuation etc.).
	func truncated(
		to maxLength: Int,
		with terminator: any StringProtocol = String.defaultTruncationTerminator,
		removeCharacters: CharacterSet? = .alphanumerics.inverted
	) -> Self {
		guard maxLength >= 0 else {
			fatalError("`maxLength` must be greater than or equal to zero.")
		}

		// Maximum length must be less than initial string length, otherwise no truncation is needed.
		guard maxLength < count else {
			return self
		}

		// Maximum length must be greater than termination string length, otherwise return plain prefix.
		guard maxLength > terminator.count else {
			return String(prefix(maxLength))
		}

		// Offset prefix length for the termination string.
		let prefixLength = maxLength - terminator.count

		var string = prefix(prefixLength)
		// Remove unwanted characters.
		if let removeCharacters {
			while let lastCharacter = string.last,
			      let unicodeScalar = Unicode.Scalar(lastCharacter),
			      removeCharacters.contains(unicodeScalar) {
				string.removeLast()
			}
		}
		return string.appending(terminator)
	}

}
