// UserDefaultRepresentable.swift, 31.03.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

/// A protocol that indicates a type can be stored in `UserDefaults`.
///
/// Types that conform to this protocol can be used with the `UserDefault` property wrapper.
///
/// - `URL` is not supported on Linux due to a flawed implementation.
/// - `Array`’s `Element` must conform to `UserDefaultRepresentable`.
/// - `Dictionary`’s `Key` must be `String`, and `Value` must conform to `UserDefaultRepresentable`.
public protocol UserDefaultRepresentable {}

extension Bool: UserDefaultRepresentable {}

extension Int: UserDefaultRepresentable {}
extension Int8: UserDefaultRepresentable {}
extension Int16: UserDefaultRepresentable {}
extension Int32: UserDefaultRepresentable {}
extension Int64: UserDefaultRepresentable {}
extension UInt: UserDefaultRepresentable {}
extension UInt8: UserDefaultRepresentable {}
extension UInt16: UserDefaultRepresentable {}
extension UInt32: UserDefaultRepresentable {}
extension UInt64: UserDefaultRepresentable {}
extension Float: UserDefaultRepresentable {}
extension Double: UserDefaultRepresentable {}

extension Data: UserDefaultRepresentable {}
extension Date: UserDefaultRepresentable {}
extension String: UserDefaultRepresentable {}
#if !os(Linux)
	extension URL: UserDefaultRepresentable {}
#endif

extension Array: UserDefaultRepresentable where Element: UserDefaultRepresentable {}
extension Dictionary: UserDefaultRepresentable where Key == String, Value: UserDefaultRepresentable {}
