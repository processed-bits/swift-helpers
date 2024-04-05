// NSBrowser+Extensions.swift, 07.09.2019-05.04.2024.
// Copyright © 2019-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	public extension NSBrowser {

		// MARK: Columns

		/// Reloads all columns.
		func reloadColumns() {
			for column in 0 ... numberOfVisibleColumns {
				reloadColumn(column)
			}
		}

		/// Asks if the specified column is a preview column.
		func isPreviewColumn(_ columnIndex: Int) -> Bool {
			guard columnIndex > 0 else {
				return false
			}
			let parentItem = parentForItems(inColumn: columnIndex)
			return isLeafItem(parentItem)
		}

		// MARK: Sizing

		/// Calculates size for the specified column to fill the remaining width of the browser.
		func sizeToFillWidth(withColumn columnIndex: Int) -> CGFloat {
			let columnFrame = frame(ofColumn: columnIndex)
			let width = frame.width - columnFrame.minX
			return width
		}

	}
#endif
