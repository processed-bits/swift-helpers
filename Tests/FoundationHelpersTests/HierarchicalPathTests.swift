// HierarchicalPathTests.swift, 18.01.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

private extension HierarchicalPath {
	/// Asserts that a string representation of the path is equal to the string, used to initialize a hierarchical path.
	@discardableResult static func assertString(
		_ string: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		let path = Self(path: string)
		let result = path.string
		let expected = string
		#expect(result == expected, sourceLocation: sourceLocation)
		return path
	}

	@discardableResult func assertLexicallyNormalized(
		_ string: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		var path = self
		path.lexicallyNormalize()
		let result = path.string
		let expected = string
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}

	@discardableResult func assertRemovedEmptyComponents(
		_ string: String,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws -> Self {
		var path = self
		path.removeEmptyComponents()
		let result = path.string
		let expected = string
		#expect(result == expected, sourceLocation: sourceLocation)
		return self
	}
}

struct HierarchicalPathTests {

	@Test func initialization() throws {
		try HierarchicalPath.assertString("")
		try HierarchicalPath.assertString("/")

		try HierarchicalPath.assertString("/x")
		try HierarchicalPath.assertString("/x/")
		try HierarchicalPath.assertString("/x//")

		try HierarchicalPath.assertString("//")
		try HierarchicalPath.assertString("//x")
		try HierarchicalPath.assertString("//x/")

		try HierarchicalPath.assertString("x")
		try HierarchicalPath.assertString("x/")
		try HierarchicalPath.assertString("x//")
	}

	@Test func lexicallyNormalize() throws {
		try HierarchicalPath(path: "/.").assertLexicallyNormalized("/")
		try HierarchicalPath(path: "/..").assertLexicallyNormalized("/")
	}

	@Test func removeEmptyComponents() throws {
		try HierarchicalPath(path: "/").assertRemovedEmptyComponents("/")
		try HierarchicalPath(path: "//").assertRemovedEmptyComponents("/")
		try HierarchicalPath(path: "///").assertRemovedEmptyComponents("/")

		try HierarchicalPath(path: "/x").assertRemovedEmptyComponents("/x")
		try HierarchicalPath(path: "//x").assertRemovedEmptyComponents("/x")
		try HierarchicalPath(path: "///x").assertRemovedEmptyComponents("/x")

		try HierarchicalPath(path: "x/").assertRemovedEmptyComponents("x/")
		try HierarchicalPath(path: "x//").assertRemovedEmptyComponents("x/")
		try HierarchicalPath(path: "x///").assertRemovedEmptyComponents("x/")

		try HierarchicalPath(path: "/x//").assertRemovedEmptyComponents("/x/")
		try HierarchicalPath(path: "//x/").assertRemovedEmptyComponents("/x/")
	}

}
