// UserDefaultRawRepresentableTests.swift, 12.02.2023-20.11.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Helpers
import XCTest

final class UserDefaultRawRepresentableTests: XCTestCase {

	private let key = "test"

	private enum TestCounter: Int, CaseIterable {
		case one = 1, two, three, four, five
	}

	private struct TestDirections: OptionSet {
		let rawValue: UInt8

		// swiftlint:disable identifier_name
		static let up = TestDirections(rawValue: 1 << 0)
		static let down = TestDirections(rawValue: 1 << 1)
		static let left = TestDirections(rawValue: 1 << 2)
		static let right = TestDirections(rawValue: 1 << 3)
		// swiftlint:enable identifier_name
	}

	func test() throws {
		try process(TestCounter.allCases.randomElement())
		try process(TestDirections([.up, .right]))
	}

	private func process<Value: RawRepresentable & Equatable>(_ value: Value?) throws {
		@UserDefaultRawRepresentable(key: key) var wrapper: Value? = value
		let pairs: KeyValuePairs<String, Any> = try [
			"Wrapper type": _wrapper,
			"Value type": Value.self,
			"Value": XCTUnwrap(value),
			"Raw value": XCTUnwrap(value).rawValue,
		]
		print(pairs.format(keyTerminator: ":"))

		XCTAssertEqual(wrapper, value)
		wrapper = nil
		XCTAssertNil(wrapper)
	}

}
