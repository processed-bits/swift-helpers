// UserDefaultRawRepresented.swift, 15.12.2020.
// Copyright © 2020-2025 Stanislav Lomachinskiy.

import Foundation

/// User defaults property wrapper for types with an associated raw value.
///
/// Stores the raw value directly. The raw value must be of a property list compatible type.
///
/// See [User Defaults Property Wrappers](<doc:UserDefaultsPropertyWrappers>), [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults), and the [`RawRepresentable`](https://developer.apple.com/documentation/swift/rawrepresentable) protocol for more information.
@propertyWrapper
public final class UserDefaultRawRepresented<Value: RawRepresentable> where Value.RawValue: UserDefaultRepresentable {

	let defaults: UserDefaults
	let key: String
	let defaultValue: Value?

	public var wrappedValue: Value? {
		get {
			if let rawValue = defaults.object(forKey: key) as? Value.RawValue,
			   let value = Value(rawValue: rawValue) {
				return value
			}
			return defaultValue
		}
		set {
			if let newValue {
				defaults.set(newValue.rawValue, forKey: key)
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
