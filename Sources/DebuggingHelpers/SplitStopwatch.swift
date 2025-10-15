// SplitStopwatch.swift, 17.04.2023.
// Copyright © 2023-2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import Foundation

	/// A stopwatch for measurement of the elapsed and lap times.
	public class SplitStopwatch: Stopwatch {

		/// The array of lap stopwatches.
		///
		/// Use this array to inspect lap measurements in the same way as you do with `Stopwatch`.
		///
		/// - Note: This array is manipulated automatically. Don’t manually manipulate the lap stopwatches.
		public private(set) var laps: [Stopwatch] = []

		// MARK: Creating a Stopwatch

		public required init(start date: Date? = .init()) {
			super.init(start: date)
			let lap = Stopwatch(start: date)
			laps.append(lap)
		}

		// MARK: Manipulating a Stopwatch

		override public func start(at date: Date = .init()) {
			super.start(at: date)
			laps.last?.start(at: date)
		}

		override public func stop(at date: Date = .init()) {
			super.stop(at: date)
			laps.last?.stop(at: date)
		}

		/// Splits the laps.
		///
		/// If the stopwatch is not running and the last lap has no measurement (has a value of `0`), a new lap is not added.
		///
		/// - Parameters:
		///   - date: The point in time for the action. The default is the current date and time.
		public func split(at date: Date = .init()) {
			// Stop the last lap.
			laps.last?.stop(at: date)
			// The last lap should have a non-zero result.
			if laps.last?.measurement.value != 0 {
				// Add a new lap. Start it only if the stopwatch is running.
				let lapStartDate = isRunning ? date : nil
				let lap = Stopwatch(start: lapStartDate)
				laps.append(lap)
			}
		}

		override public func reset() {
			super.reset()
			laps = [
				Stopwatch(start: nil),
			]
		}

		// MARK: Describing a Stopwatch

		override public var debugDescription: String {
			// Total stopwatch result.
			var string = "\(super.debugDescription)"
			var lapDescriptions: [String] = []
			// Laps results.
			for (number, lap) in laps.enumerated() {
				let lapDescription = "\(number + 1): \(lap.debugDescription)"
				lapDescriptions.append(lapDescription)
			}
			string += " [\(lapDescriptions.joined(separator: ", "))]"
			return string
		}

		override public var customMirror: Mirror {
			let children: [(String, Stopwatch)] = laps.enumerated().map { number, lap in
				(label: "\(number + 1)", value: lap)
			}
			return Mirror(
				self,
				children: children,
				ancestorRepresentation: .customized { super.customMirror }
			)
		}

	}
#endif
