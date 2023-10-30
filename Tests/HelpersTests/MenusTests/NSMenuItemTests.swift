// NSMenuItemTests.swift, 08.03.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Cocoa
import Helpers
import XCTest

final class NSMenuItemTests: XCTestCase {

	private let menu = NSMenu()

	func testInit() throws {
		let item = NSMenuItem(title: "Test Item", keyEquivalent: "T", tag: 99)
		menu.addItem(item)
		XCTAssertNotNil(item.keyEquivalent.nilIfEmpty)
		XCTAssertTrue(item.isEnabled)
	}

	func testLabel() throws {
		let item = NSMenuItem.label(title: "Label")
		menu.addItem(item)
		XCTAssertNil(item.action)
		XCTAssertNil(item.keyEquivalent.nilIfEmpty)
		XCTAssertFalse(item.isEnabled)
	}

}
