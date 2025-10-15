// NSMenuItem+Extensions.swift, 18.02.2023.
// Copyright © 2023-2024 Stanislav Lomachinskiy.

#if os(macOS)
	import AppKit

	public extension NSMenuItem {

		/// Returns an initialized instance of `NSMenuItem`.
		///
		/// - Parameters:
		///   - string: The title of the menu item.
		///   - target: The target of the menu item.
		///   - selector: The action selector to be associated with the menu item. This value must be a valid selector or `nil`.
		///   - charCode: A string representing a keyboard key to be used as the key equivalent.
		///   - image: The image of the menu item.
		///   - tag: The tag of the menu item.
		///   - representedObject: The object represented by the menu item.
		convenience init(
			title string: String,
			target: AnyObject? = nil,
			action selector: Selector? = nil,
			keyEquivalent charCode: String = "",
			image: NSImage? = nil,
			tag: Int = 0,
			representedObject: Any? = nil
		) {
			self.init(title: string, action: selector, keyEquivalent: charCode)
			self.target = target
			self.image = image
			self.tag = tag
			self.representedObject = representedObject
		}

		/// Returns a menu item that is used to label logical groups of menu commands.
		///
		/// - Parameters:
		///   - string: The title of the menu item.
		class func label(title string: String) -> Self {
			let menuItem = Self(title: string, action: nil, keyEquivalent: "")
			menuItem.isEnabled = false
			return menuItem
		}

	}
#endif
