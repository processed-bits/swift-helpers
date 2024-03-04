// NSView+Extensions.swift, 24.08.2019-06.03.2024.
// Copyright © 2019-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	public extension NSView {

		// MARK: View Hierarchy

		/// The array of buttons embedded in the current view.
		var subviewButtons: [NSButton] {
			subviews.compactMap { $0 as? NSButton }
		}

		// MARK: Appearance

		/// A Boolean value indicating whether the view is visible. Opposite to `isHidden`.
		@objc dynamic var isVisible: Bool {
			get { !isHidden }
			set(isVisible) { isHidden = !isVisible }
		}

		@objc class func keyPathsForValuesAffectingIsVisible() -> Set<String> {
			[#keyPath(isHidden)]
		}

	}
#endif
