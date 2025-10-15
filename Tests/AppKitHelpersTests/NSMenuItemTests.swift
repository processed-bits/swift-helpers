// NSMenuItemTests.swift, 08.03.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit
	import AppKitHelpers
	import Testing

	struct NSMenuItemTests {

		private let menu = NSMenu()

		@Test func initialization() throws {
			let item = NSMenuItem(title: "Test Item", keyEquivalent: "T", tag: 99)
			menu.addItem(item)
			#expect(!item.keyEquivalent.isEmpty)
			#expect(item.isEnabled)
		}

		@Test func label() throws {
			let item = NSMenuItem.label(title: "Label")
			menu.addItem(item)
			#expect(item.action == nil)
			#expect(item.keyEquivalent.isEmpty)
			#expect(!item.isEnabled)
		}

	}
#endif
