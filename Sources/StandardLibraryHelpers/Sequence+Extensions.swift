// Sequence+Extensions.swift, 18.05.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

/// Transformation helpers.
public extension Sequence {

	/// Returns an array containing the non-`nil` elements of this sequence.
	func compacted<Wrapped>() -> [Wrapped] where Element == Wrapped? {
		compactMap(\.self)
	}

}
