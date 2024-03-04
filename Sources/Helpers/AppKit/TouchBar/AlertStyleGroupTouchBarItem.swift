// AlertStyleGroupTouchBarItem.swift, 07.10.2019-06.03.2024.
// Copyright © 2019-2024 Stanislav Lomachinskiy. All rights reserved.

#if canImport(AppKit)
	import AppKit

	/// Use `AlertStyleGroupTouchBarItem` when building a group item configured to match system alerts.
	///
	/// Assign `AlertStyleGroupTouchBarItem` as a custom class in the Identity inspector.
	@available(macOS 10.12.1, macCatalyst 13.1, *)
	public class AlertStyleGroupTouchBarItem: NSGroupTouchBarItem {

		// Replaces existing group item with a group item configured to match system alerts.
		override public func awakeAfter(using coder: NSCoder) -> Any? {
			let groupTouchBarItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
			groupTouchBarItem.groupTouchBar = groupTouchBar
			return groupTouchBarItem
		}

	}
#endif
