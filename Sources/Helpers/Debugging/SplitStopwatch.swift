// SplitStopwatch.swift, 17.04.2023-25.04.2023.
// Copyright © 2023 Stanislav Lomachinskiy.

import Foundation

/// A stopwatch for measurement of the elapsed and lap times.
public class SplitStopwatch: Stopwatch {

	/// The array of lap stopwatches.
	///
	/// Use this array to inspect lap measurements in the same way as you do with `Stopwatch`.
	///
	/// - Note: This array is manipulated automatically. Don't manually manipulate the lap stopwatches.
	public private(set) var laps: [Stopwatch] = []

	// MARK: Creating a Stopwatch

	public required init(start date: Date? = .init(), precision: UInt8 = 3) {
		super.init(start: date, precision: precision)
		let lap = Stopwatch(start: date, precision: precision)
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

	/// Splits the lap.
	///
	/// - Parameters:
	///   - date: The point in time for the action. The default is the current date and time.
	public func split(at date: Date = .init()) {
		// Stop the last lap.
		laps.last?.stop(at: date)
		// The last lap should have a non-zero result.
		guard laps.last?.result != 0 else {
			return
		}
		// Add a new lap. Start it only if the stopwatch is running.
		let measurementStart = isRunning ? date : nil
		let lap = Stopwatch(start: measurementStart, precision: precision)
		laps.append(lap)
	}

	override public func reset() {
		super.reset()
		laps = [
			Stopwatch(start: nil, precision: precision),
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
		let children: [(String, Any)] = laps.enumerated().map { number, lap in
			(label: "Lap \(number + 1)", value: lap)
		}
		return Mirror(
			self,
			children: children,
			ancestorRepresentation: .customized { super.customMirror }
		)
	}

}
