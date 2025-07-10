//
//  File.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-04.
//

import Foundation


public class Spinner: Model, Focusable {
	public var messageBroker: MessageBroker? = nil
	public var focused: Bool = false
	public var disabled: Bool = false
	/// If true, this item's grey blur from being disabled will not be terminated and thus extend beyond its own view.
	var escapingDisabledColor: Bool
	
	public var value: Int
	let min: Int?
	let max: Int?
	let step: Int
	
	
	public init(startingValue: Int = 0, min: Int? = 0, max: Int? = 100, step: Int = 1, escapingDisabledColor: Bool = false) {
		self.value = startingValue
		self.min = min
		self.max = max
		self.step = step
		self.escapingDisabledColor = escapingDisabledColor
	}
	
	public func focus() async {
		focused = true
	}
	
	public func unfocus() async {
		focused = false
	}
	
	public func enable() async {
		disabled = false
	}
	
	public func disable() async {
		disabled = true
	}
	
	
	func contrainValue() {
		if let max {
			if value > max {
				value = max
			}
		}
		
		if let min {
			if value < min {
				value = min
			}
		}
	}
	
	
	public func update(msg: any RBMessage) -> (any Command)? {
		switch msg {
			case let msg as KeyPress:
				switch msg {
					case .right, .ascii("+"), .ascii("="), .ascii("]"):
						value += step
						contrainValue()
						
					case .left, .ascii("-"), .ascii("_"), .ascii("["):
						value -= step
						contrainValue()
						
					default: break
				}
			default: break
		}
		return nil
	}
	
	
	public var body: String {
		let focus = focused ? (l: "⏴".colored(value != min ? .blue : .grey), r: "⏵".colored(value != max ? .blue : .grey)) : (l: " ", r: " ")
		
		var view = "\(focus.l)\(value)\(focus.r)"
		
		
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
