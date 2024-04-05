// NSRegularExpression+Extensions.swift, 16.02.2020-05.04.2024.
// Copyright © 2020-2024 Stanislav Lomachinskiy.

import Foundation

/// Match operator, searching and replacing strings using an optional `Range`.
public extension NSRegularExpression {

	// MARK: Match Operator

	/// Returns if the regular expression matches the string.
	static func ~= (regex: NSRegularExpression, string: String) -> Bool {
		regex.numberOfMatches(in: string) > 0
	}

	// MARK: Searching Strings

	/// Returns the number of matches of the regular expression within the specified range of the string.
	func numberOfMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Int {
		let range = range ?? string.startIndex ..< string.endIndex
		return numberOfMatches(in: string, options: options, range: NSRange(range, in: string))
	}

	/// Enumerates the string allowing the block to handle each regular expression match.
	func enumerateMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil, using block: (NSTextCheckingResult?, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void) {
		let range = range ?? string.startIndex ..< string.endIndex
		enumerateMatches(in: string, options: options, range: NSRange(range, in: string), using: block)
	}

	/// Returns an array containing all the matches of the regular expression in the string.
	func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> [NSTextCheckingResult] {
		let range = range ?? string.startIndex ..< string.endIndex
		return matches(in: string, options: options, range: NSRange(range, in: string))
	}

	/// Returns the first match of the regular expression within the specified range of the string.
	func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> NSTextCheckingResult? {
		let range = range ?? string.startIndex ..< string.endIndex
		return firstMatch(in: string, options: options, range: NSRange(range, in: string))
	}

	/// Returns the range of the first match of the regular expression within the specified range of the string.
	func rangeOfFirstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Range<String.Index>? {
		let searchRange = range ?? string.startIndex ..< string.endIndex
		let resultingRange = rangeOfFirstMatch(in: string, options: options, range: NSRange(searchRange, in: string))
		return Range(resultingRange, in: string)
	}

	// MARK: Replacing Strings

	/// Replaces regular expression matches within the string using the template string.
	///
	/// - Returns: The number of matches.
	@discardableResult func replaceMatches(in string: inout String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil, withTemplate template: String) -> Int {
		let range = range ?? string.startIndex ..< string.endIndex
		let numberOfMatches = numberOfMatches(in: string, options: options, range: range)
		string = stringByReplacingMatches(in: string, options: options, range: range, withTemplate: template)
		return numberOfMatches
	}

	/// Returns a new string containing matching regular expressions replaced with the template string.
	func stringByReplacingMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil, withTemplate template: String) -> String {
		let range = range ?? string.startIndex ..< string.endIndex
		return stringByReplacingMatches(in: string, options: options, range: NSRange(range, in: string), withTemplate: template)
	}

}
