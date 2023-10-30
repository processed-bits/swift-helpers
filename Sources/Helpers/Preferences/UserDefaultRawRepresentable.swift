// UserDefaultRawRepresentable.swift, 15.12.2020-12.02.2023.
// Copyright © 2020-2023 Stanislav Lomachinskiy.

import Foundation

/// `UserDefaultRawRepresentable` property wrapper with an underlying associated raw value.
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
open class UserDefaultRawRepresentable<Value: RawRepresentable>: UserDefault<Value> {

	override public var wrappedValue: Value? {
		get {
			if let rawValue {
				return Value(rawValue: rawValue)
			} else {
				return defaultValue
			}
		}
		set {
			rawValue = newValue?.rawValue
		}
	}

	public var rawValue: Value.RawValue? {
		get {
			defaults.object(forKey: key) as? Value.RawValue ?? defaultValue?.rawValue
		}
		set {
			if let newValue {
				defaults.set(newValue, forKey: key)
			} else {
				defaults.removeObject(forKey: key)
			}
		}
	}

}
