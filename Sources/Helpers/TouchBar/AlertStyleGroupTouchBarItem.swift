// AlertStyleGroupTouchBarItem.swift, 07.10.2019-03.12.2022.
// Copyright © 2019-2022 Stanislav Lomachinskiy. All rights reserved.

import Cocoa

/// Use `AlertStyleGroupTouchBarItem` when building a group item configured to match system alerts.
///
/// Assign `AlertStyleGroupTouchBarItem` as a custom class in the Identity inspector.
@available(macOS 10.12.2, *)
public class AlertStyleGroupTouchBarItem: NSGroupTouchBarItem {

	// Replaces existing group item with a group item configured to match system alerts.
	override public func awakeAfter(using coder: NSCoder) -> Any? {
		guard #available(macOS 10.13, *) else {
			return super.awakeAfter(using: coder)
		}
		let groupTouchBarItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
		groupTouchBarItem.groupTouchBar = groupTouchBar
		return groupTouchBarItem
	}

}
