// URL+Normalization.swift, 14.04.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension URL {

	// MARK: Normalization

	/// Returns a normalized copy of the URL.
	///
	/// - Parameters:
	///   - resolve: If `true`, resolves against the base URL before normalizing. If `false`, the base URL itself is not normalized. Defaults to `false`.
	///   - lowercasePath: If `true`, the path is converted to lowercase. Do so only if licensed by the scheme specification. Defaults to `false`.
	///   - schemePortPairs: A collection of schemes and their default port values. Defaults to ``URLComponents/defaultNormalizedPorts``.
	///   - removeEmptyPathComponents: If `true`, empty path components are removed, effectively collapsing consecutive path separators. Do so only if licensed by the scheme specification. Defaults to `false`.
	///
	/// The base URL is not validated. If the URL is not resolved against its base, the base URL itself is not normalized, though you can validate and/or normalize the base URL beforehand.
	///
	/// If the URL is malformed, `nil` is returned.
	///
	/// See <doc:URLNormalization#Normalization> for more information.
	func normalized(
		resolvingAgainstBaseURL resolve: Bool = false,
		lowercasePath: Bool = false,
		schemePortPairs: [String: Int] = URLComponents.defaultNormalizedPorts,
		removeEmptyPathComponents: Bool = false
	) -> URL? {
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: resolve) else {
			return nil
		}
		components.normalize(
			lowercasePath: lowercasePath,
			schemePortPairs: schemePortPairs,
			removeEmptyPathComponents: removeEmptyPathComponents
		)

		let url = resolve ? components.url : components.url(relativeTo: baseURL)
		return url
	}

	/// Normalizes the URL.
	///
	/// - Parameters:
	///   - resolve: If `true`, resolves against the base URL before normalizing. If `false`, the base URL itself is not normalized. Defaults to `false`.
	///   - lowercasePath: If `true`, the path is converted to lowercase. Do so only if licensed by the scheme specification. Defaults to `false`.
	///   - schemePortPairs: A collection of schemes and their default port values. Defaults to ``URLComponents/defaultNormalizedPorts``.
	///   - removeEmptyPathComponents: If `true`, empty path components are removed, effectively collapsing consecutive path separators. Do so only if licensed by the scheme specification. Defaults to `false`.
	///
	/// - Returns: `true` if the URL has been normalized.
	///
	/// The base URL is not validated. If the URL is not resolved against its base, the base URL itself is not normalized, though you can validate and/or normalize the base URL beforehand.
	///
	/// If the URL is malformed, `nil` is returned.
	///
	/// See <doc:URLNormalization#Normalization> for more information.
	@discardableResult mutating func normalize(
		resolvingAgainstBaseURL resolve: Bool = false,
		lowercasePath: Bool = false,
		schemePortPairs: [String: Int] = URLComponents.defaultNormalizedPorts,
		removeEmptyPathComponents: Bool = false
	) -> Bool {
		if let normalized = normalized(
			resolvingAgainstBaseURL: resolve,
			lowercasePath: lowercasePath,
			schemePortPairs: schemePortPairs,
			removeEmptyPathComponents: removeEmptyPathComponents
		) {
			self = normalized
			return true
		}
		return false
	}

	// MARK: Lexical Normalization

	/// Returns a normalized copy of the URL by collapsing current directory (`.`) and parent directory (`..`) components lexically (i.e. without following symlinks) in its path.
	///
	/// - Parameters:
	///   - resolve: If `true`, resolves against the base URL before normalizing. If `false`, the base URL itself is not normalized. Defaults to `false`.
	///   - removeEmptyPathComponents: If `true`, empty path components are removed, effectively collapsing consecutive path separators.
	///
	/// The base URL is not validated. If the URL is not resolved against its base, the base URL itself is not normalized, though you can validate and/or normalize the base URL beforehand.
	///
	/// If the URL is malformed, `nil` is returned.
	///
	/// See <doc:URLNormalization#Lexical-Normalization> for more information.
	func lexicallyNormalized(
		resolvingAgainstBaseURL resolve: Bool = false,
		removeEmptyPathComponents: Bool = false
	) -> URL? {
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: resolve) else {
			return nil
		}
		components.normalizePathLexically(removeEmptyComponents: removeEmptyPathComponents)

		let url = resolve ? components.url : components.url(relativeTo: baseURL)
		return url
	}

	/// Normalizes the URL by collapsing current directory (`.`) and parent directory (`..`) components lexically (i.e. without following symlinks) in its path.
	///
	/// - Parameters:
	///   - resolve: If `true`, resolves against the base URL before normalizing. If `false`, the base URL itself is not normalized. Defaults to `false`.
	///   - removeEmptyPathComponents: If `true`, empty path components are removed, effectively collapsing consecutive path separators.
	///
	/// - Returns: `true` if the URL has been normalized.
	///
	/// The base URL is not validated. If the URL is not resolved against its base, the base URL itself is not normalized, though you can validate and/or normalize the base URL beforehand.
	///
	/// If the URL is malformed, `nil` is returned.
	///
	/// See <doc:URLNormalization#Lexical-Normalization> for more information.
	@discardableResult mutating func lexicallyNormalize(
		resolvingAgainstBaseURL resolve: Bool = false,
		removeEmptyPathComponents: Bool = false
	) -> Bool {
		if let lexicallyNormalized = lexicallyNormalized(
			resolvingAgainstBaseURL: resolve,
			removeEmptyPathComponents: removeEmptyPathComponents
		) {
			self = lexicallyNormalized
			return true
		}
		return false
	}

}
