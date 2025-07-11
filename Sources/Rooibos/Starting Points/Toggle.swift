//
//  File.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-01.
//

import Foundation


@frozen
public enum ToggleStyle {
	case checkbox
	case `switch`
	case radio
}


public class Toggle: Model, Focusable, Equatable {
	public var messageBroker: MessageBroker? = nil
	public var focused: Bool = false
	public var disabled: Bool = false
	public var on: Bool = false
	public weak var exclusiveGroup: ExclusiveGroup?
	
	let id: UUID
	let uncheckWhenDisabled: Bool
	let style: ToggleStyle
	public let escapingDisabledColor: Bool

	
	public init(uncheckWhenDisabled: Bool = false, style: ToggleStyle = .checkbox, escapingDisabledColor: Bool = true) {
		self.uncheckWhenDisabled = uncheckWhenDisabled
		self.style = style
		self.escapingDisabledColor = escapingDisabledColor
		self.id = UUID()
	}
	
	public func update(msg: any RBMessage) -> (any Command)? {
		guard focused else {
			return nil
		}
		
		switch msg {
			case let msg as KeyPress:
			switch msg {
				case .return, .space:
					if let exclusiveGroup {
						exclusiveGroup.toggle(self)
					} else {
						on.toggle()
					}
				default: break
			}
			default: break
		}
		
		
		return nil
	}

	
	public var body: String {
		var view: String
		switch style {
			case .switch:
				var cursor = (open: " ", close: " ")
				if focused {
					cursor = (open: "[", close: "]")
					if !disabled {
						cursor.open.color(.blue)
						cursor.close.color(.blue)
					}
				}
				
				let dot = disabled ? "•" : ( on ? "•".colored(.intenseGreen) : "•".colored(.intenseRed) )
				
				let `switch` = on ? "-" + dot : dot + "-"
				
				view = "\(cursor.open)\(`switch`)\(cursor.close) "
				
			case .checkbox, .radio:
				var cursor = " "
				if focused {
					cursor = ">"
					if !disabled {
						cursor.color(.blue)
					}
				}
				
				
				var check = " "
				if on {
					check = "x"
					if !disabled {
						check.color(.intenseGreen)
					}
				}
				
				let box = style == .checkbox ? (open: "[", close: "]") : (open: "(", close: ")")
				
				view = "\(cursor) \(box.open)\(check)\(box.close) "
		}
		
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
	
	
	
	public static func == (lhs: Toggle, rhs: Toggle) -> Bool {
		lhs.id == rhs.id
	}
}
