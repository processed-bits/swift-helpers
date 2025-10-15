// URL+Comparable.swift, 30.01.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation

extension URL: @retroactive Comparable {
	/// Returns a Boolean value indicating whether the first URL precedes the second URL.
	///
	/// URLs are compared using their components in the following order: scheme, user, password, host, port, path components, query, fragment. Each pair of the URL components is compared as sorted by the Finder.
	public static func < (lhs: Self, rhs: Self) -> Bool {
		for result in [
			// Compare scheme, user, password, host, port.
			compareComponents(lhs: lhs, rhs: rhs, using: { [$0.scheme, $0.user, $0.password, $0.host, $0.portAsString] }),
			// Compare path components.
			comparePathComponents(lhs: lhs, rhs: rhs),
			// Compare query, fragment.
			compareComponents(lhs: lhs, rhs: rhs, using: { [$0.query, $0.fragment] }),
		] {
			switch result {
			case .orderedAscending:
				return true
			case .orderedDescending:
				return false
			case .orderedSame:
				continue
			}
		}

		// If no comparisons lead to a result, return `false` to satisfy the irreflexivity condition.
		return false
	}
}

private extension URL {

	/// Compares the given components of the URLs.
	static func compareComponents(
		lhs: Self,
		rhs: Self,
		using components: (Self) -> [String?]
	) -> ComparisonResult {
		for (lhsPart, rhsPart) in zip(components(lhs), components(rhs)) {
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

	/// Compares the path components of the URLs.
	static func comparePathComponents(lhs: Self, rhs: Self) -> ComparisonResult {
		// Compare path components.
		for (lhs, rhs) in zip(lhs.pathComponents, rhs.pathComponents) {
			let result = lhs.localizedStandardCompare(rhs)
			if result == .orderedSame {
				continue
			} else {
				return result
			}
		}

		// If zipped path components are the same, compare by components count.
		switch lhs.pathComponents.count - rhs.pathComponents.count {
		case ..<0:
			return .orderedAscending
		case 1...:
			return .orderedDescending
		default:
			break
		}

		// If path components count is the same, compare if the URL path represents a directory.
		switch (lhs.hasDirectoryPath, rhs.hasDirectoryPath) {
		case (true, false):
			return .orderedAscending
		case (false, true):
			return .orderedDescending
		default:
			return .orderedSame
		}
	}

	/// The port component of the URL returned as a string for comparisons.
	var portAsString: String? {
		guard let port else {
			return nil
		}
		return String(port)
	}

}
