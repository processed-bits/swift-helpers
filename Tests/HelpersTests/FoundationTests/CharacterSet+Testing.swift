// CharacterSet+Testing.swift, 02.01.2025-03.01.2025.
// Copyright © 2025 Stanislav Lomachinskiy.

import Foundation

extension CharacterSet {

	static let empty: Self = .init()
	private static let colon: Self = .init(charactersIn: ":")

	/// Returns the character set for characters allowed in a user URL subcomponent, including a colon to reflect `URLComponents` behaviour for testing.
	static let urlUserAllowedWithColon: Self = .urlUserAllowed.union(.colon)

	/// Returns the character set for characters allowed in a password URL subcomponent, including a colon to reflect `URLComponents` behaviour for testing.
	static let urlPasswordAllowedWithColon: Self = .urlPasswordAllowed.union(.colon)

}
