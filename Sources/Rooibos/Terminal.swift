//
//  Terminal.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-06-24.
//

import Foundation


/// ANSI color code for terminal coloring.
public enum AnsiColor: Int, CustomStringConvertible, RawRepresentable {
	public var description: String {
		return "\u{001B}[\(self.rawValue)m"
	}
	
	public var str: String {
		self.description
	}
	
	public var background: String {
		// offset by 10 for background color codes
		return "\u{001B}[\(self.rawValue + 10)m"
	}
	
	case black = 30
	case red = 31
	case green = 32
	case yellow = 33
	case blue = 34
	case magenta = 35
	case cyan = 36
	case grey = 37
	
	case darkGrey = 90
	case intenseRed = 91
	case intenseGreen = 92
	case intenseYellow = 93
	case intenseBlue = 94
	case intenseMagenta = 95
	case intenseCyan = 96
	case white = 97
}


/// ANSI formatting codes for text styles.
public enum AnsiFmt: Int, CustomStringConvertible, RawRepresentable {
	public var description: String {
		return "\u{001B}[\(self.rawValue)m"
	}
	
	public var str: String {
		self.description
	}
	
	/// Resets all formatting.
	case reset = 0
	/// Marks text as _bold_.
	case bold = 1
	/// Requests text to be _italic_.
	/// - WARNING: Italic text is not supported by all terminals.
	case italic = 3
	/// _Underlines_ the text. Note that this is used by the "cursor" in textFields.
	case underline = 4
	/// Causes the text to _blink_. The cycle takes 1 second to complete.
	case blink = 5
	/// Causes the text to _blink_ rapidly.
	case rapidBlink = 6
	/// Swaps the foreground color and the background color.
	case invert = 7
	/// I actually don't know what this one does. I'll need to test it.
	case hidden = 8
	/// Marks the text as _strikethrough_.
	case strikethrough = 9
}


/// Clears the terminal by printing `\u{1b}[2J`. Then moves the cursor to 1, 1 via `\u{001B}[H`.
func clear() {
	print("\u{1b}[2J\u{001B}[H", terminator: "")
}


public func hideCursor() {
	print("\u{001B}[?25l", terminator: "")
	fflush(stdout)
}


public func showCursor() {
	print("\u{001B}[?25h", terminator: "")
	fflush(stdout)
}


public func beep() {
	print("\u{007}", terminator: "")
	fflush(stdout)
}


func enterAltBuffer() {
	print("\u{001B}[?1049h", terminator: "")
	fflush(stdout)
}

func exitAltBuffer() {
	print("\u{001B}[?1049l", terminator: "")
	fflush(stdout)
}


func warning(_ message: String) {
	print("\(Clr.intenseRed)\(Fmt.blink)WARNING\(Fmt.reset)\(Clr.red): \(message).\(Fmt.reset)")
	fflush(stdout)
}


func crashHandler(signal: Int32) -> Void {
	#if DEBUG
	print("\(Clr.intenseRed)\n\rPROGRAM PANIC.\(Fmt.reset)", terminator: "\n\r")
	print("\(Clr.magenta)PRESS ANY KEY TO RESTORE TERMINAL.\(Fmt.reset)", terminator: "\n\r")
	var char: UInt8 = 0
	let _ = read(STDIN_FILENO, &char, 1)
	#endif
	
	if var mutableOriginalTerminal = Program.originalTerminal {
		tcsetattr(STDIN_FILENO, TCSAFLUSH, &mutableOriginalTerminal)		
	}
	
	exitAltBuffer()
	showCursor()
	print("\n\r", terminator: "")
	print("\(Clr.intenseRed)The program crashed and could not continue running:", terminator: "\n\r")
	//print("", terminator: "")
	switch signal {
		case SIGTRAP: print("SIGTRAP (Trace trap was triggered) - An internal saftey check did no pass. No more information given.", terminator: "\n\r")
		case SIGINT: print("SIGINT (Inturrupt) - The program was interrupted.", terminator: "\n\r")
		case SIGSEGV: print("SIGSEGV (Segmentation fault) - Data entered a corrupted and irrecoverable state which forced the program to exit.", terminator: "\n\r")
		//case SIGABRT: print("SIGABRT (Aborted) - ", terminator: "\n\r")
		//case SIGFPE: print("SIGFPE (Floating point exception) - ", terminator: "\n\r")
		//case SIGILL: print("SIGILL (Illegal instruction) - ", terminator: "\n\r")
		case SIGQUIT: print("SIGQUIT (Quit) - The program was forced to quit.", terminator: "\n\r")
		default: print("EXC - The program encountered exeption number \(signal)", terminator: "\n\r")
	}
	print("\(Clr.blue)(crash handled - terminal restored)\(Fmt.reset)", terminator: "\n\r")
	exit(signal)
}
