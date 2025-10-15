// Comment+URLs.swift, 08.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Testing

extension Comment {
	// Initialization.
	static let urlInitRelativeFilePathTransformation: Self = "Relative path may be transformed during file path URL initialization."
	static let urlInitFilePathHomeDirectoryExpansion: Self = "Home directory is expanded during file path URL initialization."

	// Base URL.
	static let urlResolvingAgainstInvalidBase: Self = "Resolving against an invalid base URL without a host, result gains `//`."
	static let urlResolvingAgainstNoHostBase: Self = "Resolving against a base URL without a host, result gains `//`."

	// `URL` and `URLComponents` encoding.
	static let urlEncodingUserPasswordColon: Self = "`URLComponents` setters do not percent-encode `:` for the user and password components."
	static let urlEncodingHost: Self = "Deprecated `percentEncodedHost` setter removes percent-encoding for allowed characters."
	static let urlEncodingPathSemicolon: Self = "`URL` and `URLComponents` implementations percent-encode `;` in the path."
}
