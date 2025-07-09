//
//  Focusable.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-02.
//

import Foundation


public protocol Focusable {
	/// While this model is _focused_ it receives commands.
	var focused: Bool { get set }
	/// While disabled, this item should not gain focus, and instead by skipped over.
	var disabled: Bool { get set }
//	/// Focuses this element.
//	func focus() async
//	/// Removes focus from this element.
//	func unfocus() async
//	/// Enables this element.
//	func enable() async
//	/// Disables this element.
//	func disable() async
}
//public extension Focusable {
//	func focus() async {
//		focused = true
//	}
//	
//	func unfocus() async {
//		focused = false
//	}
//	
//	func enable() async {
//		disabled = false
//	}
//	
//	func disable() async {
//		disabled = true
//	}
//}
