// IndexPath+Extensions.swift, 04.12.2022.
// Copyright © 2022 Stanislav Lomachinskiy.

import Foundation

/// Node inspection helpers.
public extension IndexPath {

	// MARK: Inspecting Nodes

	/// Returns a Boolean value indicating whether the index path is an ancestor of another index path.
	func isAncestor(of other: IndexPath) -> Bool {
		self != other && other.starts(with: self)
	}

	/// Returns a Boolean value indicating whether the index path is a descendant of another index path.
	func isDescendant(of other: IndexPath) -> Bool {
		self != other && starts(with: other)
	}

}
