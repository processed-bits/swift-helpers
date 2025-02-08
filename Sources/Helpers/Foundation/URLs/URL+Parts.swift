// URL+Parts.swift, 05.04.2024-21.12.2024.
// Copyright © 2024 Stanislav Lomachinskiy.

import Foundation

public extension URL {

	// MARK: Accessing the Parts of a URL

	/// The non-extension portion of the file or directory last component.
	var stem: String? {
		let stem = deletingPathExtension().lastPathComponent
		return stem.nilIfEmpty
	}

}
