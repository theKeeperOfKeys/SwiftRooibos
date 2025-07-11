//
//  LineEdit.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-04.
//

import Foundation


// │




public class LineEdit: Model, Focusable {
	public var messageBroker: MessageBroker? = nil
	public var focused: Bool = false
	public var disabled: Bool = false
	public let escapingDisabledColor: Bool = false
	
	let characterWhitelist: CharacterSet?
	let characterBlacklist: CharacterSet?
	let maxChars: Int?
	let placeholder: String
	let label: String
	
	public var value: String = ""
		
	public init(label: String, placeholder: String = "", maxChars: Int? = nil, allowOnly: CharacterSet? = nil, dontAllow: CharacterSet? = nil) {
		self.label = label
		self.placeholder = placeholder
		self.characterWhitelist = allowOnly
		self.characterBlacklist = dontAllow
		self.maxChars = maxChars
	}
	
	func addCharacter(_ char: Character) {
		if let maxChars {
			guard value.count < maxChars else {
				return
			}
		}
		
		if let characterWhitelist {
			guard char.unicodeScalars.allSatisfy({ characterWhitelist.contains($0) }) else {
				return
			}
		}
		
		if let characterBlacklist {
			guard char.unicodeScalars.allSatisfy({ !characterBlacklist.contains($0) }) else {
				return
			}
		}
		
		value.append(char)
	}
	
	
	public func update(msg: any RBMessage) -> (any Command)? {
		switch msg {
			case let msg as KeyPress:
				switch msg {
					case .ascii(let char):
						addCharacter(char)
					case .number(let num), .numpad(let num):
						if let char = String(num).first {
							addCharacter(char)
						}
					case .clear:
						value = ""
					case .space:
						addCharacter(" ")
					case .tab:
						addCharacter("\t")
					case .delete:
						if value.popLast() == nil { // could not pop?
							beep()
						}
					case .return:
						return FocusGroupCmd.focusNext
					default: break
				}
			default: break
		}
		
		return nil
	}
	
	
	public var body: String {
		let displayVal = disabled ? (value.isEmpty && !focused ? placeholder : value) : (value.isEmpty && !focused ? placeholder.colored(.grey) : value.colored(.green))
		let cursor = focused ? "│".colored(.intenseGreen) : ""
		let displayLabel = focused ? label.colored(.blue) : label
		
		var view = "\(displayLabel): \(displayVal)\(cursor)"

		
		if disabled {
			if escapingDisabledColor {
				view = Clr.darkGrey.str + view
			} else {
				view.color(.darkGrey)
			}
		} else {
			view.style(.reset)
		}
		
		return view
	}
}
