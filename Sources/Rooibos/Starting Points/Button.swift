//
//  Button.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-07.
//

import Foundation

public class Button: Model, Focusable {
	public var messageBroker: MessageBroker? = nil
	public var focused = false
	public var disabled = false
	let label: String
	let action: () -> (any Command)?
	
	public init(label: String, action: @escaping () -> (any Command)?) {
		self.label = label
		self.action = action
	}
		
	public func update(msg: any RBMessage) -> (any Command)? {
		guard focused else {
			return nil
		}
		
		switch msg {
			case let msg as KeyPress: switch msg {
				case .space, .return:
					return action()
				default: break
			}
			default: break
		}
		
		return nil
	}
	
	public var body: String {
		var view = "[\(label)]"
		if disabled {
			view.color(.darkGrey)
		} else if focused {
			view.color(.blue)
		}
		return view
	}
}
