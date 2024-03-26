// IndexPathTests.swift, 05.12.2022-20.02.2023.
// Copyright © 2022-2023 Stanislav Lomachinskiy.

import XCTest

final class IndexPathTests: XCTestCase {

	private let nestedIndexPaths: [IndexPath] = [
		[0],
		[0, 1],
		[0, 1, 2],
		[0, 1, 2, 3],
	]
	private let unrelatedIndexPath: IndexPath = [9, 8]

	func testAncestor() throws {
		let ancestorIndexPath = try XCTUnwrap(nestedIndexPaths.first)
		for indexPath in nestedIndexPaths.dropFirst() {
			XCTAssertTrue(ancestorIndexPath.isAncestor(of: indexPath))
		}
		for indexPath in nestedIndexPaths {
			XCTAssertFalse(unrelatedIndexPath.isAncestor(of: indexPath))
		}
	}

	func testDescendant() throws {
		let descendantIndexPath = try XCTUnwrap(nestedIndexPaths.last)
		for indexPath in nestedIndexPaths.dropLast() {
			XCTAssertTrue(descendantIndexPath.isDescendant(of: indexPath))
		}
		for indexPath in nestedIndexPaths {
			XCTAssertFalse(unrelatedIndexPath.isDescendant(of: indexPath))
		}
	}

}
