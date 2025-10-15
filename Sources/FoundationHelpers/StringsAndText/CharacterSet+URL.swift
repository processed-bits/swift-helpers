// CharacterSet+URL.swift, 15.04.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

public extension CharacterSet {

	// MARK: Getting Character Sets for URL Encoding

	static let urlUserAllowedRFC3986: CharacterSet = .urlUnreservedRFC3986
		.union(.urlSubDelimitersRFC3986)

	static let urlPasswordAllowedRFC3986: CharacterSet = .urlUnreservedRFC3986
		.union(.urlSubDelimitersRFC3986)

	static let urlHostAllowedRFC3986: CharacterSet = .urlUnreservedRFC3986
		.union(.urlSubDelimitersRFC3986)
		.union(.init(charactersIn: "[]:"))

	static let urlPathAllowedRFC3986: CharacterSet = .urlUnreservedRFC3986
		.union(.urlSubDelimitersRFC3986)
		.union(.init(charactersIn: "/:@"))

	static let urlQueryAllowedRFC3986: CharacterSet = .urlPathAllowedRFC3986
		.union(.init(charactersIn: "?"))

	static let urlFragmentAllowedRFC3986: CharacterSet = .urlPathAllowedRFC3986
		.union(.init(charactersIn: "?"))

	// MARK: Private Helpers

	private static let urlUnreservedRFC3986 = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")

	private static let urlSubDelimitersRFC3986 = CharacterSet(charactersIn: "!$&'()*+,;=")

}
