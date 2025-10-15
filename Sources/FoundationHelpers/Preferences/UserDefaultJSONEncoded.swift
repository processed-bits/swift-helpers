// UserDefaultJSONEncoded.swift, 30.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

/// User defaults property wrapper for `Codable`-conforming types.
///
/// Stores the value’s JSON representation as a data object.
///
/// See [User Defaults Property Wrappers](<doc:UserDefaultsPropertyWrappers>), [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults), and the [`Codable`](https://developer.apple.com/documentation/swift/codable) protocol for more information.
@propertyWrapper
public final class UserDefaultJSONEncoded<Value: Codable> {

	let defaults: UserDefaults
	let key: String
	let defaultValue: Value?

	private typealias Encoder = JSONEncoder
	private typealias Decoder = JSONDecoder

	public var wrappedValue: Value? {
		get {
			if let data = defaults.data(forKey: key),
			   let value = try? Decoder().decode(Value.self, from: data) {
				return value
			}
			return defaultValue
		}
		set {
			if let newValue,
			   let data = try? Encoder().encode(newValue) {
				defaults.set(data, forKey: key)
			} else {
				defaults.removeObject(forKey: key)
			}
		}
	}

	public init(
		defaults: UserDefaults = .standard,
		key: String,
		defaultValue: Value? = nil
	) {
		self.defaults = defaults
		self.key = key
		self.defaultValue = defaultValue
	}

	public convenience init(
		wrappedValue: Value?,
		defaults: UserDefaults = .standard,
		key: String,
		defaultValue: Value? = nil
	) {
		self.init(defaults: defaults, key: key, defaultValue: defaultValue)
		self.wrappedValue = wrappedValue
	}

}
