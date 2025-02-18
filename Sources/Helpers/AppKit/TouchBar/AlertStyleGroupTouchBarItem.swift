// AlertStyleGroupTouchBarItem.swift, 07.10.2019-15.02.2025.
// Copyright © 2019-2025 Stanislav Lomachinskiy. All rights reserved.

#if canImport(AppKit)
	import AppKit

	/// Use `AlertStyleGroupTouchBarItem` when building a group item configured to match system alerts.
	///
	/// Assign `AlertStyleGroupTouchBarItem` as a custom class in the Identity inspector.
	@available(macOS 10.15, macCatalyst 13.1, *)
	public class AlertStyleGroupTouchBarItem: NSGroupTouchBarItem {

		/// Replaces existing group item with a group item configured to match system alerts.
		override public func awakeAfter(using coder: NSCoder) -> Any? {
			#if compiler(>=6)
				let item = MainActor.assumeIsolated {
					let groupTouchBarItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
					groupTouchBarItem.groupTouchBar = groupTouchBar
					return groupTouchBarItem
				}
				return item
			#else
				let groupTouchBarItem = NSGroupTouchBarItem(alertStyleWithIdentifier: identifier)
				groupTouchBarItem.groupTouchBar = groupTouchBar
				return groupTouchBarItem
			#endif
		}

	}
#endif
