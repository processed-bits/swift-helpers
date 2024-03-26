// File.swift, 14.04.2023-23.03.2024.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

/// Checks that an expression is not `nil`, and returns the unwrapped value.
///
/// This function prevents the program from proceeding when `expression` is `nil`. Otherwise, it returns the unwrapped value of `expression`.
///
/// See [preconditionFailure(_:file:line:)](https://developer.apple.com/documentation/swift/preconditionfailure(_:file:line:)) for more information.
///
/// - Parameters:
///   - expression: An expression of type `T?`. The expression’s type determines the type of the return value.
///   - message: A string to print if `expression` is evaluated to `nil` in a playground or `-Onone` build. The default is an empty string.
///   - file: The file name to print with `message` if the precondition fails. The default is the file where `preconditionUnwrap(_:_:file:line:)` is called.
///   - line: The line number to print along with `message` if the precondition fails. The default is the line number where `preconditionUnwrap(_:_:file:line:)` is called.
///
/// - Returns: The result of evaluating and unwrapping the `expression`, which is of type `T`. `preconditionUnwrap(_:_:file:line:)` only returns a value if `expression` is not `nil`.
public func preconditionUnwrap<T>(_ expression: @autoclosure () throws -> T?, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) rethrows -> T {
	guard let value = try expression() else {
		preconditionFailure(message(), file: file, line: line)
	}
	return value
}
