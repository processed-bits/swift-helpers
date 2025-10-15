// NSTreeController+Extensions.swift, 24.01.2020.
// Copyright © 2020-2025 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit
	import FoundationHelpers

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
			topmostSelectedNodes.map(\.representedObject)
		}

		/// An array containing the tree controller’s topmost selected tree nodes.
		var topmostSelectedNodes: [NSTreeNode] {
			let topmostSelectionIndexPaths = topmostSelectionIndexPaths
			return selectedNodes.filter { treeNode in
				topmostSelectionIndexPaths.contains(treeNode.indexPath)
			}
		}

	}
#endif
