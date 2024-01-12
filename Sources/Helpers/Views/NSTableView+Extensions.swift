// NSTableView+Extensions.swift, 28.12.2020-04.12.2022.
// Copyright © 2020-2022 Stanislav Lomachinskiy.

import Cocoa

public extension NSTableView {

	// MARK: Scrolling

	/// Scrolls the view so the first selected row is visible.
	func scrollRowToFirstSelected() {
		if let index = selectedRowIndexes.min() {
			scrollRowToVisible(index)
		}
	}

}
