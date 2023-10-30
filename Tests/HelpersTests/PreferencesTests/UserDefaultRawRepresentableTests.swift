// UserDefaultRawRepresentableTests.swift, 12.02.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class UserDefaultRawRepresentableTests: UserDefaultTestCase {

	@UserDefaultRawRepresentable(key: "test") var testProperty: TestValue?

	enum TestValue: Int, CaseIterable {
		case one = 1, two, three, four, five
	}

	func test() throws {
		// No value.
		print(label: Label.type, value: _testProperty)
		print(label: Label.notSet, value: testProperty as Any)
		XCTAssertNil(testProperty)

		// Non-nil value.
		testProperty = TestValue.allCases.randomElement()
		print(label: Label.set, value: testProperty as Any)
		let unwrappedRawValue = try XCTUnwrap(_testProperty.rawValue)
		XCTAssertEqual(testProperty, TestValue(rawValue: unwrappedRawValue))

		// Removed value.
		testProperty = nil
		print(label: Label.removed, value: testProperty as Any)
		XCTAssertNil(testProperty)
	}

}
