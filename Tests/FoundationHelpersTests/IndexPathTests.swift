// IndexPathTests.swift, 05.12.2022.
// Copyright © 2022-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import Testing

struct IndexPathTests {

	private let nestedIndexPaths: [IndexPath] = [
		[0],
		[0, 1],
		[0, 1, 2],
		[0, 1, 2, 3],
	]
	private let unrelatedIndexPath: IndexPath = [9, 8]

	@Test func ancestor() throws {
		let ancestorIndexPath = try #require(nestedIndexPaths.first)
		for indexPath in nestedIndexPaths.dropFirst() {
			#expect(ancestorIndexPath.isAncestor(of: indexPath))
		}
		for indexPath in nestedIndexPaths {
			#expect(!unrelatedIndexPath.isAncestor(of: indexPath))
		}
	}

	@Test func descendant() throws {
		let descendantIndexPath = try #require(nestedIndexPaths.last)
		for indexPath in nestedIndexPaths.dropLast() {
			#expect(descendantIndexPath.isDescendant(of: indexPath))
		}
		for indexPath in nestedIndexPaths {
			#expect(!unrelatedIndexPath.isDescendant(of: indexPath))
		}
	}

}
