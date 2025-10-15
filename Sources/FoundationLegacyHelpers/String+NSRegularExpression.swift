// String+NSRegularExpression.swift, 01.02.2022.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Foundation

public extension String {

	// MARK: Escaping Characters

	/// A string made by adding backslash escapes as necessary to protect any characters that would match as pattern metacharacters.
	@inlinable var regexEscapedPattern: String {
		NSRegularExpression.escapedPattern(for: self)
	}

	/// A template string made by adding backslash escapes as necessary to protect any characters that would match as pattern metacharacters.
	@inlinable var regexEscapedTemplate: String {
		NSRegularExpression.escapedTemplate(for: self)
	}

}
