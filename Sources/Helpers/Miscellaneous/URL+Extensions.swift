// URL+Extensions.swift, 30.01.2022-04.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Foundation

extension URL: Comparable {

	// MARK: `Comparable` Implementation

	/// Returns a Boolean value indicating whether the first URL precedes the second URL.
	///
	/// URLs are compared using their parts in the following order: scheme, user, password, host, port, path components, query, fragment. Each pair of the URL parts is compared as sorted by the Finder.
	public static func < (lhs: Self, rhs: Self) -> Bool {
		// Compare scheme, user, password, host, port.
		if let isPreceding = isPrecedingUsingParts(lhs: lhs, rhs: rhs, parts: {
			[$0.scheme, $0.user, $0.password, $0.host, $0.portAsString]
		}) {
			return isPreceding
		}
		// Compare path components.
		if let isPreceding = isPrecedingUsingPathComponents(lhs: lhs, rhs: rhs) {
			return isPreceding
		}
		// Compare query, fragment.
		if let isPreceding = isPrecedingUsingParts(lhs: lhs, rhs: rhs, parts: {
			[$0.query, $0.fragment]
		}) {
			return isPreceding
		}
		// If no comparisons lead to a result, return `false` to satisfy the irreflexivity condition.
		return false
	}

	/// Returns a Boolean value indicating whether the first URL precedes the second URL compared by the path components of URLs. Returns `nil` if the path components are equal.
	private static func isPrecedingUsingPathComponents(lhs: Self, rhs: Self) -> Bool? {
		// Compare path components.
		for (lhs, rhs) in zip(lhs.pathComponents, rhs.pathComponents) {
			switch lhs.localizedStandardCompare(rhs) {
			case .orderedAscending:
				return true
			case .orderedDescending:
				return false
			case .orderedSame:
				continue
			}
		}
		// If zipped path components are the same, but the counts of components are not equal, compare by count.
		if lhs.pathComponents.count != rhs.pathComponents.count {
			return lhs.pathComponents.count < rhs.pathComponents.count
		}
		return nil
	}

	/// Returns a Boolean value indicating whether the first URL precedes the second URL compared by the given parts of URLs. Returns `nil` if all the part pairs are equal.
	private static func isPrecedingUsingParts(lhs: Self, rhs: Self, parts: (Self) -> [String?]) -> Bool? {
		let comparisonResult = compare(lhs: lhs, rhs: rhs, parts: parts)
		switch comparisonResult {
		case .orderedAscending:
			return true
		case .orderedDescending:
			return false
		case .orderedSame:
			return nil
		}
	}

	/// Compares the given parts of URLs.
	private static func compare(lhs: Self, rhs: Self, parts: (Self) -> [String?]) -> ComparisonResult {
		for (lhsPart, rhsPart) in zip(parts(lhs), parts(rhs)) {
			switch (lhsPart, rhsPart) {
			case let (.some(lhsPart), .some(rhsPart)):
				let result = lhsPart.localizedStandardCompare(rhsPart)
				if result != .orderedSame {
					return result
				}
			case (nil, .some(_)):
				return .orderedAscending
			case (.some(_), nil):
				return .orderedDescending
			case (nil, nil):
				continue
			}
		}
		return .orderedSame
	}

	/// The port component of the URL returned as a string for comparisons.
	private var portAsString: String? {
		guard let port else {
			return nil
		}
		return String(port)
	}

}

public extension URL {

	// MARK: Relative URLs

	/// Makes a URL that is relative to a base URL.
	///
	/// If `base` is `nil` or is not a prefix of `self`, this method does nothing.
	@inlinable mutating func relativize(to base: URL?) {
		self = relativeURL(to: base)
	}

	/// Returns a URL that is relative to a base URL.
	///
	/// If `base` is `nil` or is not a prefix of `self`, this method returns `self`.
	func relativeURL(to base: URL?) -> URL {
		// URLs must be standardized for path components comparison.
		let pathComponents = standardized.pathComponents
		let basePathComponents = base?.standardized.pathComponents
		// Checks if `base` is not `nil` and is a prefix of `self`.
		guard let basePathComponents,
		      basePathComponents == Array(pathComponents.prefix(upTo: basePathComponents.count)) else {
			return self
		}
		// Prepare relative path components.
		var relativePathComponents = pathComponents.suffix(from: basePathComponents.count)
		if relativePathComponents.isEmpty {
			relativePathComponents.append("")
		}
		// Make new URL.
		var url: URL
		if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
			url = URL(filePath: relativePathComponents.removeFirst(), relativeTo: base)
		} else {
			url = URL(fileURLWithPath: relativePathComponents.removeFirst(), relativeTo: base)
		}
		while !relativePathComponents.isEmpty {
			let component = relativePathComponents.removeFirst()
			url.appendPathComponent(component)
		}
		return url
	}

}
