// UserDefaultTests.swift, 12.02.2023-08.02.2025.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class UserDefaultTests: XCTestCase {

	private let key = "test"

	func test() throws {
		try process(URL(string: "https://test.com"))
		try process("Test")
		try process(Data())
		try process(true)
		try process(1)
		try process(Float(1))
		try process(Double(1))
		try process(["Test"])
		try process([true])
		try process(["Key": "Value"])
	}

	private func process<Value: Equatable>(_ value: Value?) throws {
		@UserDefault(key: key) var wrapper: Value? = value
		let pairs: KeyValuePairs<String, Any> = try [
			"Wrapper type": _wrapper,
			"Value type": Value.self,
			"Value": XCTUnwrap(value),
		]
		print(pairs.formatted(keySuffix: ":"))

		XCTAssertEqual(wrapper, value)
		wrapper = nil
		XCTAssertNil(wrapper)
	}

}
