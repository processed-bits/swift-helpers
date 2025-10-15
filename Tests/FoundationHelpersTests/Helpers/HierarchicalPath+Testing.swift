// HierarchicalPath+Testing.swift, 18.01.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers

extension HierarchicalPath {
	@discardableResult func dump() -> Self {
		Swift.dump(self)
		return self
	}
}
