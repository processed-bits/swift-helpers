// BufferedOutputProviding.swift, 26.03.2023.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

// swiftlint:disable deployment_target

/// A type that provides a buffered output object.
@available(iOS 8.0, macOS 10.10, macCatalyst 13.0, tvOS 9.0, watchOS 2.0, *)
public protocol BufferedOutputProviding {
	/// The buffered output.
	var bufferedOutput: BufferedOutput { get }
}

// swiftlint:enable deployment_target
