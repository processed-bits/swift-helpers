// UserDefaultTestCase.swift, 13.02.2023-15.04.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import XCTest

class UserDefaultTestCase: XCTestCase {
	// swiftlint:disable test_case_accessibility

	enum Label: String, CaseIterable {
		case type = "Type"
		case notSet = "Not set"
		case set = "Set"
		case removed = "Removed"

		static let columnWidth = {
			let longestLabel = allCases.map { $0.rawValue.count }.max() ?? 0
			return longestLabel + 1
		}()
	}

	func print(label: Label, value: Any) {
		let labelText = label.rawValue + ":"
		if let value = value as? any RawRepresentable, let rawValue = value.rawValue as? Int {
			Swift.print(labelText.padding(toLength: Label.columnWidth), value, "(\(rawValue))")
		} else {
			Swift.print(labelText.padding(toLength: Label.columnWidth), String(describing: value))
		}
	}

	// swiftlint:enable test_case_accessibility
}
