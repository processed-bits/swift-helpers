// NSTreeControllerTests.swift, 04.12.2022-20.02.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class NSTreeControllerTests: XCTestCase {

	// MARK: Node

	@objc private class MockObject: NSObject {

		let id: Int
		let type: String
		@objc let children: [MockObject]

		init(id: Int, type: String, children: [MockObject] = []) {
			self.id = id
			self.type = type
			self.children = children
		}

	}

	// MARK: Tree Controller

	private let treeController = NSTreeController()
	private let content = MockObject(
		id: 0,
		type: "Root",
		children: [
			MockObject(
				id: 0,
				type: "Intermediate",
				children: [
					MockObject(
						id: 0,
						type: "Leaf"
					),
					MockObject(
						id: 1,
						type: "Leaf"
					),
				]
			),
			MockObject(
				id: 1,
				type: "Intermediate",
				children: [
					MockObject(
						id: 0,
						type: "Leaf"
					),
				]
			),
			MockObject(
				id: 2,
				type: "Leaf"
			),
		]
	)
	private let selectionIndexPaths: [IndexPath] = [
		[0, 0],
		[0, 0, 1],
		[0, 0, 2],
		[0, 1, 0],
		[0, 2],
	]
	private let expectedTopmostSelectionIndexPaths: [IndexPath] = [
		[0, 0],
		[0, 1, 0],
		[0, 2],
	]

	// MARK: Tests

	override func setUp() {
		super.setUp()
		treeController.childrenKeyPath = #keyPath(MockObject.children)
		treeController.content = content
		treeController.setSelectionIndexPaths(selectionIndexPaths)
	}

	func testTopmostSelectionIndexPaths() {
		XCTAssertEqual(treeController.topmostSelectionIndexPaths, expectedTopmostSelectionIndexPaths)
	}

	func testTopmostSelectedObjects() {
		for (object, indexPath) in zip(treeController.topmostSelectedObjects, expectedTopmostSelectionIndexPaths) {
			let object = object as? MockObject
			let expectedObject = treeController.arrangedObjects.descendant(at: indexPath)?.representedObject as? MockObject
			XCTAssertEqual(object, expectedObject)
		}
	}

	func testTopmostSelectedNodes() {
		for (node, indexPath) in zip(treeController.topmostSelectedNodes, expectedTopmostSelectionIndexPaths) {
			XCTAssertEqual(node.indexPath, indexPath)
		}
	}

}
