// UserDefault.swift, 29.02.2020.
// Copyright © 2020-2025 Stanislav Lomachinskiy.

import Foundation

/// User defaults property wrapper.
///
/// Stores the value directly. The value must be of a property list compatible type.
///
/// See [User Defaults Property Wrappers](<doc:UserDefaultsPropertyWrappers>), and [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) for more information.
@propertyWrapper
public final class UserDefault<Value: UserDefaultRepresentable> {

	let defaults: UserDefaults
	let key: String
	let defaultValue: Value?

	public var wrappedValue: Value? {
		get {
			if Value.self is URL.Type {
				defaults.url(forKey: key) as? Value ?? defaultValue
			} else {
				defaults.object(forKey: key) as? Value ?? defaultValue
			}
		}
		set {
			if let newValue = newValue as? URL {
				defaults.set(newValue, forKey: key)
			} else if let newValue {
				defaults.set(newValue, forKey: key)
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
