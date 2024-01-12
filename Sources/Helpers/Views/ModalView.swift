// ModalView.swift, 02.05.2020-02.12.2022.
// Copyright © 2020-2022 Stanislav Lomachinskiy.

import Cocoa

/// Use `ModalView` when building a custom modal window stored in a nib file, usually managed by a `NSWindowController`.
///
/// Assign `ModalView` as a custom class in the Identity inspector.
open class ModalView: NSView {

	override public var acceptsFirstResponder: Bool { true }

}
