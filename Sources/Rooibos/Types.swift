//
//  Types.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-06-23.
//

import Foundation


public typealias Clr = AnsiColor
public typealias Fmt = AnsiFmt


enum RawModeError: Error {
	case notATerminal
	case failedToGetTerminalSetting
	case failedToSetTerminalSetting
}

/// A command returned by Models requesting a change or action. You can create your own custom commands, but ensure that only ``AppCmd``s are surfaced to the ``Program`` or else it will exit.
public protocol Command {}


/// A command for the ``Program`` to preform.
public enum AppCmd: Command {
	case quit
	case changeModel(any Model)
}


public protocol Model {
	/// Run when this model is loaded by the ``Program``.
	func startup() -> Command?
	/// Called when a meaningful change is encountered.
	/// - Parameter msg: The meaning of the update. An ``RBMessage``.
	/// - Returns: A ``Command`` to be passed on. Ensure that only ``AppCmd``s are passed to the ``Program``.
	mutating func update(msg: RBMessage) -> Command?
	/// The textual representation of this model. This is what is rendered to the terminal. Be sure to use the String extensions provided by this package for proper formatting.
	var body: String { get }
}
public extension Model {
	func startup() -> Command? {
		nil
	}
}
