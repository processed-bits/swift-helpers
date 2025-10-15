// Stopwatch.swift, 15.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import Foundation

	/// A stopwatch for measurement of the elapsed time.
	public class Stopwatch: CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {

		/// The total elapsed time of the stopwatch.
		public var measurement: Measurement<UnitDuration> {
			if let ongoingMeasurement = ongoingMeasurement(to: Date()) {
				recordedMeasurement + ongoingMeasurement
			} else {
				recordedMeasurement
			}
		}

		/// A Boolean that is `true` if the stopwatch is running.
		public var isRunning: Bool { measurementStart != nil }

		// MARK: Creating a Stopwatch

		/// Creates a stopwatch.
		///
		/// If you choose not to start the stopwatch when creating, you should start it later.
		///
		/// - Parameters:
		///   - date: The point in time for the start. The default is the current date and time. Pass `nil` if you will start the stopwatch later.
		public required init(start date: Date? = .init()) {
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
				// swiftlint:disable:next shorthand_operator
				recordedMeasurement = recordedMeasurement + ongoingMeasurement
			}
			measurementStart = nil
		}

		/// Resets the stopwatch and leaves it in the stopped state.
		public func reset() {
			measurementStart = nil
			recordedMeasurement = .init(value: 0, unit: .seconds)
		}

		// MARK: Private Measurement Properties and Methods

		/// The point in time when the stopwatch have started.
		private var measurementStart: Date?

		/// The recorded stopwatch measurement.
		private var recordedMeasurement = Measurement<UnitDuration>(value: 0, unit: .seconds)

		/// Returns the ongoing measurement between the stopwatch start point in time and the given point in time, if any.
		private func ongoingMeasurement(to date: Date) -> Measurement<UnitDuration>? {
			guard let measurementStart, measurementStart < date else {
				return nil
			}
			let timeInterval = date.timeIntervalSince(measurementStart)
			return .init(value: timeInterval, unit: .seconds)
		}

		// MARK: Describing a Stopwatch

		/// A description with the elapsed time in seconds.
		public var description: String {
			if #available(iOS 15.0, macCatalyst 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
				measurement.formatted(Self.formatStyle)
			} else {
				Self.formatter.string(from: measurement)
			}
		}

		/// A debug description of the stopwatch.
		public var debugDescription: String {
			var string = description
			if isRunning {
				string += ", running"
			}
			return string
		}

		public var customMirror: Mirror {
			var children: [(String, Any)] = [
				("measurement", measurement),
			]
			if isRunning {
				children.append(("isRunning", isRunning))
			}
			return Mirror(
				self,
				children: children
			)
		}

		// MARK: Formatting String Representations

		/// The format style used to create string representations of measurements.
		@available(iOS 15.0, macCatalyst 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
		public static var formatStyle: Measurement<UnitDuration>.FormatStyle {
			.measurement(
				width: .abbreviated,
				numberFormatStyle: .number
					.precision(.fractionLength(3))
			)
		}

		/// The formatter that provides localized representations of measurements.
		@available(iOS, introduced: 10.0, deprecated: 15.0)
		@available(macCatalyst, introduced: 13.1, deprecated: 15.0)
		@available(macOS, introduced: 10.12, deprecated: 12.0)
		@available(tvOS, introduced: 10.0, deprecated: 15.0)
		@available(watchOS, introduced: 3.0, deprecated: 8.0)
		public static var formatter: MeasurementFormatter {
			let formatter = MeasurementFormatter()
			formatter.unitOptions = .providedUnit
			formatter.unitStyle = .medium
			formatter.numberFormatter.maximumFractionDigits = 3
			formatter.numberFormatter.minimumFractionDigits = 3
			return formatter
		}

	}
#endif
