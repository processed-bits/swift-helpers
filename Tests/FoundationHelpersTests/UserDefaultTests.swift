// UserDefaultTests.swift, 12.02.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

import Foundation
import FoundationHelpers
import StandardLibraryHelpers
import Testing

@Suite(.serialized) struct UserDefaultTests {

	private let key = "test"

	@Test func userDefault() throws {
		try testUserDefault(true)

		try testUserDefault(Int(1))
		try testUserDefault(Float(3.14))
		try testUserDefault(Double(3.14159))

		try testUserDefault(Data(nonzeroBits: [0], minByteCount: 8))
		try testUserDefault(Date.now)
		try testUserDefault("Example")
		#if !os(Linux)
			try testUserDefault(URL(requireString: "https://example.com"))
		#endif

		try testUserDefault([true])
		try testUserDefault(["Example"])
		try testUserDefault(["Key": "Value"])
	}

	@Test func userDefaultRawRepresentable() throws {
		let number = try #require(TestNumber.allCases.randomElement())
		try testUserDefaultRawRepresented(number)

		let directions1: TestDirections = .up
		try testUserDefaultRawRepresented(directions1)

		let directions2: TestDirections = [.up, .right]
		try testUserDefaultRawRepresented(directions2)
	}

	@Test func userDefaultCodable() throws {
		try testUserDefaultJSONEncoded(URL(string: "https://example.com"))
	}

	#if os(Linux)
		@Test func url() throws {
			let defaults = UserDefaults.standard
			let url = try #require(URL(string: "https://example.com"))

			defaults.set(url, forKey: key)
			withKnownIssue(.userDefaultsURLLinux) {
				#expect(defaults.url(forKey: key) == url)
			}

			defaults.removeObject(forKey: key)
			#expect(defaults.url(forKey: key) == nil)
		}
	#endif

	// MARK: Private Methods

	private func testUserDefault<Value: UserDefaultRepresentable & Equatable>(
		_ value: Value,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		@UserDefault(key: key) var wrapper: Value? = value
		#expect(wrapper == value, sourceLocation: sourceLocation)

		let pairs: KeyValuePairs<String, Any> = try [
			"Wrapper type": _wrapper,
			"Wrapper value": #require(wrapper, sourceLocation: sourceLocation),
			"Value type": Value.self,
			"Value": value,
		]
		print(pairs.formatted(keySuffix: ":"))

		wrapper = nil
		#expect(wrapper == nil, sourceLocation: sourceLocation)
	}

	private func testUserDefaultRawRepresented<Value: RawRepresentable & Equatable>(
		_ value: Value,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws where Value.RawValue: UserDefaultRepresentable {
		@UserDefaultRawRepresented(key: key) var wrapper: Value? = value

		try withKnownIssue(.userDefaultsOptionSetLinux) {
			#expect(wrapper == value, sourceLocation: sourceLocation)

			let pairs: KeyValuePairs<String, Any> = try [
				"Wrapper type": _wrapper,
				"Wrapper value": #require(wrapper, sourceLocation: sourceLocation),
				"Value type": Value.self,
				"Value": value,
				"Raw value": value.rawValue,
			]
			print(pairs.formatted(keySuffix: ":"))
		} when: {
			Condition.isLinux && value is (any OptionSet)
		}

		wrapper = nil
		#expect(wrapper == nil, sourceLocation: sourceLocation)
	}

	private func testUserDefaultJSONEncoded<Value: Codable & Equatable>(
		_ value: Value,
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		@UserDefaultJSONEncoded(key: key) var wrapper: Value? = value
		#expect(wrapper == value, sourceLocation: sourceLocation)

		let pairs: KeyValuePairs<String, Any> = try [
			"Wrapper type": _wrapper,
			"Wrapper value": #require(wrapper, sourceLocation: sourceLocation),
			"Value type": Value.self,
			"Value": value,
		]
		print(pairs.formatted(keySuffix: ":"))

		wrapper = nil
		#expect(wrapper == nil, sourceLocation: sourceLocation)
	}

	// MARK: Supporting Types

	private enum TestNumber: Int, CaseIterable {
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

}
