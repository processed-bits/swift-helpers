// NSTreeControllerTests.swift, 04.12.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit
	import AppKitHelpers
	import Testing

	struct NSTreeControllerTests {

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

		init() {
			treeController.childrenKeyPath = #keyPath(MockObject.children)
			treeController.content = content
			treeController.setSelectionIndexPaths(selectionIndexPaths)
		}

		@Test func topmostSelectionIndexPaths() {
			#expect(treeController.topmostSelectionIndexPaths == expectedTopmostSelectionIndexPaths)
		}

		@Test func topmostSelectedObjects() {
			for (object, indexPath) in zip(treeController.topmostSelectedObjects, expectedTopmostSelectionIndexPaths) {
				let object = object as? MockObject
				let expectedObject = treeController.arrangedObjects.descendant(at: indexPath)?.representedObject as? MockObject
				#expect(object == expectedObject)
			}
		}

		@Test func topmostSelectedNodes() {
			for (node, indexPath) in zip(treeController.topmostSelectedNodes, expectedTopmostSelectionIndexPaths) {
				#expect(node.indexPath == indexPath)
			}
		}

	}
#endif
