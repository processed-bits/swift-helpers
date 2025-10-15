// URLNormalizationTest.swift, 17.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

#if canImport(System)
	import Foundation
	import FoundationHelpers
	import System
	import Testing

	/// A structure for testing URL normalization methods.
	///
	/// All assertions, except for those testing `normalized` and `lexicallyNormalized` methods, are non-strict (wrapped as intermittent known issues).
	///
	/// Assertion and debugging methods allow chaining by returning self.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	struct URLNormalizationTest {

		/// The tested URL.
		let url: URL

		/// If `true`, resolves against the base URL before normalizing.
		private let resolve: Bool
		/// If `true`, the path is converted to lowercase.
		private let lowercasePath: Bool
		/// If `true`, empty path components are removed, effectively collapsing consecutive path separators.
		private let removeEmptyPathComponents: Bool

		/// The expected normalization result as a string.
		private let expected: String

		private func failComment(_ function: String = #function) -> Comment { "\(function) fail for input URL: \(url.description)" }

		// MARK: Life Cycle

		/// Creates a normalization test with a URL from the `string`, relative to the `baseString`. The default for `resolve` (when no explicit value is given) is `true` if the URL has a base, otherwise `false`.
		init(
			string: String,
			relativeTo baseString: String? = nil,
			resolve: Bool? = nil,
			lowercasePath: Bool = false,
			removeEmptyPathComponents: Bool = false,
			expected: String,
			sourceLocation: SourceLocation = #_sourceLocation
		) throws {
			let base: URL? = if let baseString {
				try URL(requireString: baseString, sourceLocation: sourceLocation)
			} else {
				nil
			}

			try self.init(
				url: URL(requireString: string, relativeTo: base, sourceLocation: sourceLocation),
				resolve: resolve,
				lowercasePath: lowercasePath,
				removeEmptyPathComponents: removeEmptyPathComponents,
				expected: expected
			)
		}

		/// Creates a normalization test with a file URL from the `path`, relative to the `basePath`. The default for `resolve` (when no explicit value is given) is `true` if the URL has a base, otherwise `false`.
		///
		/// If the path is relative and no explicit base URL is given, file URL initializer assigns current working directory as the base URL.
		init(
			filePath path: String,
			relativeTo basePath: String? = nil,
			resolve: Bool? = nil,
			lowercasePath: Bool = false,
			removeEmptyPathComponents: Bool = false,
			expected: String
		) {
			let base: URL? = if let basePath {
				URL(filePath: basePath)
			} else {
				nil
			}
			let url = URL(filePath: path, relativeTo: base)

			lazy var isAbsolute = url.absoluteString == url.relativeString
			lazy var hasBase = url.baseURL != nil
			// The URL will be resolved if `resolve` is `true` or `nil`, and a base URL is present.
			lazy var willResolve = resolve != false && hasBase

			// File URL initializer always specifies the `file` scheme for an absolute path or for a base URL. A base URL is always present for a relative path. If the URL will be resolved or is absolute, add `file://` prefix to the expected string.
			let expected = if willResolve || isAbsolute {
				"file://\(expected)"
			} else {
				expected
			}

			self.init(
				url: url,
				resolve: resolve,
				lowercasePath: lowercasePath,
				removeEmptyPathComponents: removeEmptyPathComponents,
				expected: expected
			)
		}

		/// Creates a normalization test with a URL using components, relative to the `baseString`. The default for `resolve` (when no explicit value is given) is `true` if the URL has a base, otherwise `false`.
		init(
			scheme: String? = nil,
			host: String? = nil,
			path: String,
			relativeTo base: URL? = nil,
			resolve: Bool? = nil,
			lowercasePath: Bool = false,
			removeEmptyPathComponents: Bool = false,
			expected: String,
			sourceLocation: SourceLocation = #_sourceLocation
		) throws {
			try self.init(
				url: URLComponents(scheme: scheme, host: host, path: path).requireURL(relativeTo: base, sourceLocation: sourceLocation),
				resolve: resolve,
				lowercasePath: lowercasePath,
				removeEmptyPathComponents: removeEmptyPathComponents,
				expected: expected
			)
		}

		/// Creates a normalization test with a URL. The default for `resolve` (when no explicit value is given) is `true` if the URL has a base, otherwise `false`.
		init(
			url: URL,
			resolve: Bool? = nil,
			lowercasePath: Bool = false,
			removeEmptyPathComponents: Bool = false,
			expected: String
		) {
			lazy var hasBase = url.baseURL != nil

			self.url = url
			// The default is to resolve if there is a base URL.
			self.resolve = resolve ?? hasBase
			self.lowercasePath = lowercasePath
			self.removeEmptyPathComponents = removeEmptyPathComponents
			self.expected = expected
		}

		// MARK: Assertions

		/// Asserts that an absolute string equals the expected string.
		@discardableResult func assertAbsoluteString(sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
			let result = url.absoluteString

			withKnownIssue(isIntermittent: true, sourceLocation: sourceLocation) {
				#expect(result == expected, failComment(), sourceLocation: sourceLocation)
			}
			return self
		}

		// MARK: Normalization Assertions

		/// Asserts that a normalized URL string equals the expected string.
		@discardableResult func assertNormalized(sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
			let normalizedURL = url.normalized(
				resolvingAgainstBaseURL: resolve,
				lowercasePath: lowercasePath,
				removeEmptyPathComponents: removeEmptyPathComponents
			)
			let result = try #require(normalizedURL, sourceLocation: sourceLocation).relativeString

			#expect(result == expected, failComment(), sourceLocation: sourceLocation)
			return self
		}

		/// Asserts that a lexically normalized URL string equals the expected string.
		@discardableResult func assertLexicallyNormalized(sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
			let normalizedURL = url.lexicallyNormalized(
				resolvingAgainstBaseURL: resolve,
				removeEmptyPathComponents: removeEmptyPathComponents
			)
			let result = try #require(normalizedURL, sourceLocation: sourceLocation).relativeString

			#expect(result == expected, failComment(), sourceLocation: sourceLocation)
			return self
		}

		// MARK: URL Properties Assertions

		/// Asserts that a standardized URL string equals the expected string.
		@discardableResult func assertStandardized(sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
			let standardizedURL = (resolve ? url.absoluteURL : url).standardized
			let result = standardizedURL.relativeString

			withKnownIssue(isIntermittent: true, sourceLocation: sourceLocation) {
				#expect(result == expected, failComment(), sourceLocation: sourceLocation)
			}
			return self
		}

		/// Asserts that a standardized file URL string equals the expected string.
		///
		/// `standardizedFileURL` always resolves against base URL.
		///
		/// Only file URLs are allowed. Only absolute or resolved test URLs are allowed. Relative file URLs are resolved against current working directory, so they are excluded.
		@discardableResult func assertStandardizedFile(sourceLocation: SourceLocation = #_sourceLocation) throws -> Self {
			guard url.isFileURL else {
				Issue.record("Not a file URL, remove test assertion.", sourceLocation: sourceLocation)
				return self
			}
			guard resolve || url.isAbsolute else {
				Issue.record("Not an absolute or resolved URL, remove test assertion.", sourceLocation: sourceLocation)
				return self
			}

			let standardizedFileURL = url.standardizedFileURL
			let result = standardizedFileURL.relativeString

			withKnownIssue(isIntermittent: true, sourceLocation: sourceLocation) {
				#expect(result == expected, failComment(), sourceLocation: sourceLocation)
			}
			return self
		}

		// MARK: FilePath Method Assertion

		/// Asserts that a string using a lexically normalized `FilePath` equals the expected string.
		///
		/// `FilePath` will normalize separators by removing redundant intermediary separators and stripping any trailing separators.
		@discardableResult func assertLexicallyNormalizedFilePath(
			sourceLocation: SourceLocation = #_sourceLocation
		) throws -> Self {
			guard url.isFileURL else {
				Issue.record("Not a file URL, remove test assertion.", sourceLocation: sourceLocation)
				return self
			}

			let filePath = FilePath((resolve ? url.absoluteURL : url).path(percentEncoded: false))
			var result = filePath.lexicallyNormalized().string

			// If the URL is resolved or is absolute, add the scheme prefix to the expected string.
			if resolve || url.isAbsolute {
				let prefix = url.absoluteString.commonPrefix(with: "file://")
				result = prefix + result
			}

			withKnownIssue(isIntermittent: true, sourceLocation: sourceLocation) {
				#expect(result == expected, failComment(), sourceLocation: sourceLocation)
			}
			return self
		}

		// MARK: Debugging

		/// Dumps the URL. This method is intended only for development of the tests.
		@discardableResult func dump() -> Self {
			url.dump()
			return self
		}

	}
#endif
