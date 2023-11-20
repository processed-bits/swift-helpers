// UserDefaultRawRepresentable.swift, 15.12.2020-20.11.2023.
// Copyright © 2020-2023 Stanislav Lomachinskiy.

import Foundation

/// `UserDefaultRawRepresentable` property wrapper with an underlying associated raw value. See [`RawRepresentable`](https://developer.apple.com/documentation/swift/rawrepresentable) protocol.
///
/// This property wrapper follows the conventions of [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) class.
///
/// Usually you don't need to provide a `defaults` instance, the shared [`standard`](https://developer.apple.com/documentation/foundation/userdefaults/1416603-standard) defaults object will be used. For a screen saver a `defaults` instance must be provided by [`init(forModuleWithName:)`](https://developer.apple.com/documentation/screensaver/screensaverdefaults/1512473-init).
///
/// Getting the property value searches the domains included in the search list in the order in which they are listed and returns the object associated with the first occurrence of the specified default.
///
/// Setting the property value to `nil` removes the value in the application domain. Setting a default has no effect on the returned value if the same key exists in a domain that precedes the application domain in the search list.
///
/// Default values may be specified either app-globally using [`register(defaults:)`](https://developer.apple.com/documentation/foundation/userdefaults/1417065-register) ([`registrationDomain`](https://developer.apple.com/documentation/foundation/userdefaults/1415953-registrationdomain) is added to the end of the search list) or using a `defaultValue` when initializing respective property wrapper (its value is returned after the end of the search list).
@propertyWrapper
open class UserDefaultRawRepresentable<Value: RawRepresentable> {

	let defaults: UserDefaults
	let key: String
	let defaultValue: Value?
	private var userDefault: UserDefault<Value.RawValue>

	public var wrappedValue: Value? {
		get {
			guard let rawValue = userDefault.wrappedValue, let value = Value(rawValue: rawValue) else {
				return defaultValue
			}
			return value
		}
		set {
			userDefault.wrappedValue = newValue?.rawValue
		}
	}

	public init(defaults: UserDefaults = .standard, key: String, defaultValue: Value? = nil) {
		self.defaults = defaults
		self.key = key
		self.defaultValue = defaultValue
		userDefault = UserDefault(defaults: defaults, key: key, defaultValue: defaultValue?.rawValue)
	}

	public convenience init(wrappedValue: Value? = nil, defaults: UserDefaults = .standard, key: String, defaultValue: Value? = nil) {
		self.init(defaults: defaults, key: key, defaultValue: defaultValue)
		userDefault = UserDefault(wrappedValue: wrappedValue?.rawValue, defaults: defaults, key: key, defaultValue: defaultValue?.rawValue)
	}

}
