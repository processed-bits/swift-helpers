// NSTreeController+Extensions.swift, 24.01.2020-04.12.2022.
// Copyright © 2020-2022 Stanislav Lomachinskiy.

import Cocoa

/// Topmost selection helpers.
public extension NSTreeController {

	// MARK: Getting the Topmost Selection

	/// An array containing the index paths of the topmost selected objects.
	var topmostSelectionIndexPaths: [IndexPath] {
		selectionIndexPaths.filter { filteredIndexPath in
			// Topmost index path is not a descendant of any other index path of the collection.
			!selectionIndexPaths.contains { indexPath in
				filteredIndexPath.isDescendant(of: indexPath)
			}
		}
	}

	/// An array containing the topmost selected objects in the tree controller’s content.
	var topmostSelectedObjects: [Any?] {
		topmostSelectedNodes.map { $0.representedObject }
	}

	/// An array containing the tree controller’s topmost selected tree nodes.
	var topmostSelectedNodes: [NSTreeNode] {
		let topmostSelectionIndexPaths = topmostSelectionIndexPaths
		return selectedNodes.filter { treeNode in
			topmostSelectionIndexPaths.contains(treeNode.indexPath)
		}
	}

}
