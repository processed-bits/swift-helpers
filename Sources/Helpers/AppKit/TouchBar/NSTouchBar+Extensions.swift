// NSTouchBar+Extensions.swift, 04.03.2020-06.03.2024.
// Copyright © 2020-2024 Stanislav Lomachinskiy.

#if canImport(AppKit)
	import AppKit

	/// Bar items helper.
	@available(macOS 10.12.1, macCatalyst 13.1, *)
	public extension NSTouchBar {

		/// The list of current items in the Touch Bar.
		var items: [NSTouchBarItem] {
			itemIdentifiers.compactMap { item(forIdentifier: $0) }
		}

	}
#endif
