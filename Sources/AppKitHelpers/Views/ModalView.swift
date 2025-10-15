// ModalView.swift, 02.05.2020.
// Copyright © 2020-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	/// Use `ModalView` when building a custom modal window stored in a nib file, usually managed by a `NSWindowController`.
	///
	/// Assign `ModalView` as a custom class in the Identity inspector.
	open class ModalView: NSView {

		override public var acceptsFirstResponder: Bool { true }

	}
#endif
