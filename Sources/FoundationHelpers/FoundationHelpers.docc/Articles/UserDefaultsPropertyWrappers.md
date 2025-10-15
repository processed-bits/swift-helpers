# User Defaults Property Wrappers

@Options {
	@AutomaticSeeAlso(disabled)
}

## Choosing a User Defaults Wrapper

User defaults property wrappers provide a convenient interface to the user’s defaults database using [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults). The wrappers allow specifying a user defaults object and a default value.

Wrapper | Stores | Type Constraints
--- | --- | ---
`UserDefault` | Value | Property list compatible
`UserDefaultRawRepresented`| Raw value | Property list compatible `RawValue`
`UserDefaultJSONEncoded` | Data | `Codable`

For a list of property list compatible types, see the ``UserDefaultRepresentable`` protocol.

```swift
@UserDefault(key: "lastUpdateCheck") var lastUpdateCheck: Date?
@UserDefaultRawRepresented(key: "uiMode", defaultValue: .system) var uiMode: UIMode?
@UserDefaultJSONEncoded(key: "workspaceBookmark") var workspaceBookmark: URLBookmark?
```

## Specifying a User Defaults Object

A user defaults object may be provided using the `defaults` parameter of a wrapper.

The shared [`standard`](https://developer.apple.com/documentation/foundation/userdefaults/1416603-standard) instance is used by default.

You may provide an instance by [`init(suiteName:)`](https://developer.apple.com/documentation/foundation/userdefaults/1409957-init). For a screen saver, a `defaults` instance must be provided by [`init(forModuleWithName:)`](https://developer.apple.com/documentation/screensaver/screensaverdefaults/init(formodulewithname:)).

## Getting, Setting, and Removing a Value 

The property wrappers follow the conventions of the [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) class.

Getting the property value searches the domains included in the search list in the order in which they are listed and returns the object associated with the first occurrence of the specified default.

Setting the property value to `nil` removes the value in the application domain. Setting a default has no effect on the returned value if the same key exists in a domain that precedes the application domain in the search list.

Default values may be specified either app-globally using [`register(defaults:)`](https://developer.apple.com/documentation/foundation/userdefaults/1417065-register) ([`registrationDomain`](https://developer.apple.com/documentation/foundation/userdefaults/1415953-registrationdomain) is added to the end of the search list) or using a `defaultValue` when initializing a property wrapper (its value is returned only by the wrapper and after the search list).

## See Also

- ``UserDefault``
- ``UserDefaultRawRepresented``
- ``UserDefaultJSONEncoded``
- ``UserDefaultRepresentable``
