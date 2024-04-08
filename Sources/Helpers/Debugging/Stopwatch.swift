// Stopwatch.swift, 15.04.2023-25.04.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

/// A stopwatch for measurement of the elapsed time.
public class Stopwatch: CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {

	/// The total elapsed time of the stopwatch.
	public var result: TimeInterval {
		if let ongoingMeasurement = ongoingMeasurement(to: Date()) {
			return recordedMeasurement + ongoingMeasurement
		} else {
			return recordedMeasurement
		}
	}

	/// A Boolean that is `true` if the stopwatch is running.
	public var isRunning: Bool { measurementStart != nil }

	/// The number of decimal figures to display in the description.
	public let precision: UInt8
	/// The maximum allowed number of decimal figures to display in the description, which is `6`.
	private static let maxPrecision: UInt8 = 6

	// MARK: Creating a Stopwatch

	/// Creates a stopwatch.
	///
	/// If you choose not to start the stopwatch when creating, you should start it later.
	///
	/// - Parameters:
	///   - start: The point in time for the start. The default is the current date and time. Pass `nil` if you will start the stopwatch later.
	///   - precision: The number of decimal figures to display in the description. The default is `3`. Valid range is `0...6`.
	public required init(start date: Date? = .init(), precision: UInt8 = 3) {
		self.precision = min(precision, Self.maxPrecision)
		if let date {
			measurementStart = date
		}
	}

	// MARK: Manipulating a Stopwatch

	/// Starts the stopwatch.
	///
	/// - Parameters:
	///   - date: The point in time for the action. The default is the current date and time.
	public func start(at date: Date = .init()) {
		guard measurementStart == nil else {
			return
		}
		measurementStart = date
	}

	/// Stops the stopwatch.
	///
	/// - Parameters:
	///   - date: The point in time for the action. The default is the current date and time.
	public func stop(at date: Date = .init()) {
		if let ongoingMeasurement = ongoingMeasurement(to: date) {
			recordedMeasurement += ongoingMeasurement
		}
		measurementStart = nil
	}

	/// Resets the stopwatch and leaves it in the stopped state.
	public func reset() {
		measurementStart = nil
		recordedMeasurement = 0
	}

	// MARK: Private Measurement Properties and Methods

	/// The point in time when the stopwatch have started.
	private var measurementStart: Date?

	/// The recorded stopwatch measurement.
	private var recordedMeasurement: TimeInterval = 0

	/// Returns the ongoing measurement between the stopwatch start date and the given date.
	private func ongoingMeasurement(to date: Date) -> TimeInterval? {
		guard let measurementStart, measurementStart < date else {
			return nil
		}
		return date.timeIntervalSince(measurementStart)
	}

	// MARK: Describing a Stopwatch

	/// A description with the elapsed time in seconds.
	public var description: String {
		let format = "%1.\(precision)f s"
		return String(format: format, result)
	}

	/// A debug description of the stopwatch.
	public var debugDescription: String {
		let format = "%1.\(precision)f s"
		var string = String(format: format, result)
		if isRunning {
			string += ", running"
		}
		return string
	}

	public var customMirror: Mirror {
		var children: [(String, Any)] = [
			("result", result),
		]
		if isRunning {
			children.append(("isRunning", isRunning))
		}
		return Mirror(
			self,
			children: children
		)
	}

}
