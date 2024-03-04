// StringProtocol+Padding.swift, 16.12.2017-07.03.2024.
// Copyright © 2017-2024 Stanislav Lomachinskiy.

public extension StringProtocol {

	// MARK: Padding

	/// Returns a new string by either removing characters from a side, or by appending as many occurrences as necessary of a given pad string.
	///
	/// - Parameters:
	///   - newLength: New length for the string. `newLength` must be greater than or equal to zero.
	///   - padString: The pad string. Defaults to a single space.
	///   - padSide: The side to pad the string.
	func padding(toLength newLength: Int, withPad padString: String = " ", padSide: String.PaddingSide = .trailing) -> String {
		guard newLength >= 0 else {
			fatalError("Negative count not allowed")
		}
		switch (newLength, padSide) {
		case (count, _):
			return String(self)
		case (...count, .trailing):
			return String(prefix(newLength))
		case (...count, .leading):
			return String(suffix(newLength))
		default:
			let paddingLength = newLength - count
			let repeatCount = paddingLength / padString.count
			let remainder = paddingLength % padString.count
			if padSide == .trailing {
				return [
					String(self),
					String(padString.suffix(remainder)),
					String(repeating: padString, count: repeatCount),
				].joined()
			} else {
				return [
					String(repeating: padString, count: repeatCount),
					String(padString.prefix(remainder)),
					String(self),
				].joined()
			}
		}
	}

}
