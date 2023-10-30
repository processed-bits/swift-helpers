// NSTouchBar+Extensions.swift, 04.03.2020-03.12.2022.
// Copyright © 2020-2022 Stanislav Lomachinskiy.

import Cocoa

/// Bar items helper.
@available(macOS 10.12.1, *)
public extension NSTouchBar {

	/// The list of current items in the Touch Bar.
	var items: [NSTouchBarItem] {
		itemIdentifiers.compactMap { item(forIdentifier: $0) }
	}

}
