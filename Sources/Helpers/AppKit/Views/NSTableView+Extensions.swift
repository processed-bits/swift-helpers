// NSTableView+Extensions.swift, 28.12.2020-06.03.2024.
// Copyright © 2020-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	public extension NSTableView {

		// MARK: Scrolling

		/// Scrolls the view so the first selected row is visible.
		func scrollRowToFirstSelected() {
			if let index = selectedRowIndexes.min() {
				scrollRowToVisible(index)
			}
		}

	}
#endif
