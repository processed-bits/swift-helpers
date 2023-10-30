// UserDefaultTests.swift, 12.02.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class UserDefaultTests: UserDefaultTestCase {

	@UserDefault(key: "test") var testProperty: String?

	func test() throws {
		// No value.
		print(label: Label.type, value: _testProperty)
		print(label: Label.notSet, value: testProperty as Any)
		XCTAssertNil(testProperty)

		// Non-nil value.
		testProperty = "Test value"
		print(label: Label.set, value: testProperty as Any)
		XCTAssertNotNil(testProperty)

		// Removed value.
		testProperty = nil
		print(label: Label.removed, value: testProperty as Any)
		XCTAssertNil(testProperty)
	}

}
