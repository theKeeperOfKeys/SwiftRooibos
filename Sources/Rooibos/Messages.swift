//
//  Messages.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-08.
//

import Foundation

public protocol RBMessage: Sendable {
	
}


/// Notification telling you that a key was pressed.
public enum KeyPress: RBMessage, CustomStringConvertible {
	case escape
	case delete
	case forwardDelete
	case pageUp
	case pageDown
	case tab
	case `return`
	//case enter
	case end
	case home
	case fn
	case clear
	case up /// The up arrow key.
	case down /// The down arrow key.
	case left /// The left arrow key.
	case right /// The right arrow key.
	case numpad(Int) /// A number from the numpad.
	case number(Int) /// A number from the numbert
	case space
	case ascii(Character) /// An ascii character in the range 32 to 126, ignoring cases already covered like numbers and space.
	case f1
	case f2
	case f3
	case f4
	case f5
	case f6
	case f7
	case f8
	case f9
	case f10
	case f11
	case f12
	case eject /// The eject key.
	
	public var description: String {
		switch self {
			case .escape: "esc"
			case .delete: "del"
			case .forwardDelete: "fdel"
			case .pageUp: "pgup"
			case .pageDown: "pgdwn"
			case .tab: "tab"
			case .return: "ret"
			//case .enter: "entr"
			case .end: "end"
			case .home: "home"
			case .fn: "fn"
			case .clear: "clr"
			case .up: "↑"
			case .down: "↓"
			case .left: "←"
			case .right: "→"
			case .numpad(let num): String(num)
			case .number(let num): String(num)
			case .space: "␣"
			case .ascii(let char): String(char)
			case .f1: "f1"
			case .f2: "f2"
			case .f3: "f3"
			case .f4: "f4"
			case .f5: "f5"
			case .f6: "f6"
			case .f7: "f7"
			case .f8: "f8"
			case .f9: "f9"
			case .f10: "f10"
			case .f11: "f11"
			case .f12: "f12"
			case .eject: "eject"
		}
	}
}


/// Messages relating to window updates.
public enum WindowMsg: RBMessage {
//	/// Notification for when the window looses focus.
//	case focusLost
//	/// Notification for when the window gains focus.
//	case focusGained
	/// Notification for when the window is resized. Includes the new dimensions.
	case resized((x: Int, y: Int))
}


/// A tick to update the view.
public struct Tick: RBMessage {
	public init() {}
}
