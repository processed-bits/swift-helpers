// Regex+Extensions.swift, 12.11.2022-07.03.2024.
// Copyright © 2022-2024 Stanislav Lomachinskiy.

/// Match operator.
@available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
public extension Regex {

	// MARK: Match Operator

	/// Returns if the regular expression matches the string.
	static func ~= (regex: Self, string: String) -> Bool {
		string.contains(regex)
	}

}
