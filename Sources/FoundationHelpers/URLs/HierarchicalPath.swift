// HierarchicalPath.swift, 30.11.2024.
// Copyright © 2024-2025 Stanislav Lomachinskiy.

import Foundation

/// A type that represents a hierarchical path.
///
/// A hierarchical path may be initialized explicitly, using a path string, or from a URL.
///
/// This type is intended for path components comparison, normalization and manipulation.
public struct HierarchicalPath: Equatable, Hashable {

	/// A Boolean that is true if the path is absolute.
	public var isAbsolute: Bool

	/// The components of a path.
	public var components: [String]

	/// A Boolean that is true if the path has a directory reference.
	///
	/// The string representation will have a trailing separator only if there are any components, including empty ones.
	public var hasDirectoryPath: Bool

	/// A Boolean that is true if the path references root.
	public var isRoot: Bool { isAbsolute && components.isEmpty }

	// MARK: Life Cycle

	/// Creates a hierarchical path.
	public init(components: [String] = [], isAbsolute: Bool, hasDirectoryPath: Bool) {
		self.components = components
		self.isAbsolute = isAbsolute
		self.hasDirectoryPath = hasDirectoryPath
	}

	/// Creates a hierarchical path from a string representation.
	public init(path: String) {
		var path = path

		// Determine if the path is absolute and remove the leading separator.
		isAbsolute = path.hasPrefix(.separator)
		if isAbsolute {
			path.removeFirst()
		}

		if path.isEmpty {
			components = []
			hasDirectoryPath = false
		} else if path == .separator {
			// If the path has only a trailing separator now, assign an empty component to preserve the trailing separator in the string representation.
			components = [""]
			hasDirectoryPath = true
		} else {
			// Determine if the path has a directory reference and remove the trailing separator.
			hasDirectoryPath = path.hasSuffix(.separator)
			if hasDirectoryPath {
				path.removeLast()
			}

			// Return components including empty ones to preserve each separator.
			components = path
				.split(separator: Character(.separator), omittingEmptySubsequences: false)
				.map(String.init)
		}
	}

	/// Creates a hierarchical path from a URL.
	///
	/// If the URL has a base, this initializer will resolve against base URL and use the resulting path.
	@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
	public init(from url: URL) {
		self.init(path: url.absoluteURL.path(percentEncoded: false))
	}

	// MARK: Constructing a String

	/// The string representation of the path.
	public var string: String {
		var string = ""

		if isAbsolute {
			string += .separator
		}

		string += components.joined(separator: .separator)

		// Add a trailing separator only if there are any components.
		if hasDirectoryPath, !components.isEmpty {
			string += .separator
		}

		return string
	}

	// MARK: Manipulating a Path

	/// Removes the empty path components of self, essentially removing any consecutive path separators.
	public mutating func removeEmptyComponents() {
		components.removeAll { $0.isEmpty }
	}

	/// Removes the last path component of self, if the component has a non-directory reference.
	public mutating func removeNonDirectoryComponent() {
		if !hasDirectoryPath, !components.isEmpty {
			components.removeLast()
			hasDirectoryPath = true
		}
	}

	// MARK: Normalizing a Path Lexically

	/// Normalizes the path by collapsing current directory (`.`) and parent directory (`..`) components lexically (i.e. without following symlinks).
	public mutating func lexicallyNormalize() {
		self = lexicallyNormalized
	}

	private var lexicallyNormalized: Self {
		var input = self
		var output = Self(isAbsolute: isAbsolute, hasDirectoryPath: hasDirectoryPath)

		while !input.components.isEmpty {
			let component = input.components.removeFirst()
			lazy var hasParentDirectory = !output.components.isEmpty && output.components.last != .parentDirectory
			lazy var isLastComponent = input.components.isEmpty

			switch (component, hasParentDirectory) {
			case (.currentDirectory, _):
				// Current directory component.
				// Drop the current directory component.

				// Make a directory reference, if the current directory component is last and the path isn’t root.
				if isLastComponent, !output.isRoot {
					output.hasDirectoryPath = true
				}

			case (.parentDirectory, true):
				// Parent directory component with some parent directory available.
				// Remove the parent directory component.
				output.components.removeLast()

				// Make a directory reference, if the parent directory component is last.
				if isLastComponent {
					output.hasDirectoryPath = true
				}

			case (.parentDirectory, false):
				// Parent directory component with no parent directory available.
				// Keep the parent directory component if the path is relative (the path may be resolved later). If the path is absolute, drop the extraneous parent directory component (it is meaningless and cannot be resolved).
				if !isAbsolute {
					output.components.append(component)
				}

			default:
				output.components.append(component)
			}
		}

		return output
	}

	// MARK: Normalizing a Relative-Path Reference

	/// Normalizes the path for a relative-path reference.
	///
	/// The first component of a relative-path reference cannot contain a colon or be empty. This method will prepend a current directory component to preserve the reference kind.
	///
	/// - Note: Use this method **only** on URLs with a relative-path reference.
	///
	/// See RFC 3986 [Section 4.2](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) for more information.
	public mutating func normalizeRelativePathReference() {
		guard !isAbsolute, let first = components.first else {
			return
		}
		if first.contains(":") || first.isEmpty {
			components = [.currentDirectory] + components
		}
	}

}

// MARK: - Conformances

extension HierarchicalPath: ExpressibleByStringLiteral {
	public typealias StringLiteralType = String
	public typealias ExtendedGraphemeClusterLiteralType = String
	public typealias UnicodeScalarLiteralType = String

	public init(stringLiteral value: String) {
		self.init(path: value)
	}
}

extension HierarchicalPath: CustomStringConvertible {
	public var description: String { string }
}

// MARK: - Private Helpers

/// Hierarchical path extensions.
private extension String {
	static let separator = "/"
	static let currentDirectory = "."
	static let parentDirectory = ".."
}
