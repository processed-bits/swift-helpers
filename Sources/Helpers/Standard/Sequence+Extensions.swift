// Sequence+Extensions.swift, 18.05.2022-05.05.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Foundation

/// Transformation helpers.
public extension Sequence {

	/// Returns an array containing the non-`nil` elements of this sequence.
	func compacted<Wrapped>() -> [Wrapped] where Element == Wrapped? {
		compactMap { $0 }
	}

}
