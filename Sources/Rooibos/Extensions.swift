//
//  Extensions.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-06-27.
//

import Foundation

public extension String {
	/// Returns itself but with newline suitable for raw terminal mode at the end. (\n and \r together)
	var line: String {
		return self + "\n\r"
	}

	/// Returns itself with an ANSI color code to the start of the string, and adds an ANSI reset to the end.
	func colored(_ color: AnsiColor) -> String {
		return color.str + self + Fmt.reset.str
	}
	
	
	/// Adds an ANSI color code to the start of the string, and adds an ANSI reset to the end.
	mutating func color(_ color: AnsiColor) {
		self = self.colored(color)
	}
	
	/// Adds an ANSI format code to the start of the string, and adds an ANSI reset to the end.
	func styled(_ format: AnsiFmt) -> String {
		return format.str + self + Fmt.reset.str
	}
	
	
	mutating func style(_ format: AnsiFmt) {
		self = self.styled(format)
	}
	
	/// Adds a newline to the string suitable for raw terminal mode. (\n and \r together)
	mutating func addLine() {
		self += "\n\r"
	}
}
