//
//  File.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-01.
//

import Foundation


public enum FocusGroupCmd: Command {
	case focusNext
	case focusPrev
}


public class FocusGroup {
	public var items: [any Focusable & Model]
	public private(set) var focusedItem: Int = 0
	
	
	public init(items: [any Focusable & Model]) {
		precondition(!items.isEmpty, "Precondition Violated: FocusGroup must have at least one focusable item.\n(Serious developer issue.)")
		self.items = items
	}
	
	
	public func focusNext() {
		let newFocusIdx = getNextIndex()
		items[focusedItem].focused = false
		items[newFocusIdx].focused = true
		focusedItem = newFocusIdx
	}
	
	
	public func focusPrev() {
		let newFocusIdx = getPrevIndex()
		items[focusedItem].focused = false
		items[newFocusIdx].focused = true
		focusedItem = newFocusIdx
	}
	
	
	public func focus(_ idx: Int) {
		items[focusedItem].focused = false
		items[idx].focused = true
		focusedItem = idx
	}
	
	
	/// Returns the currently focused item so you can update it manually.
	public func getFocused() -> any Focusable & Model {
		items[focusedItem]
	}
	
	
	/// Updates the currently focused item.
	/// - Parameter msg: Message to send to the item.
	/// - Returns: Command returned. Will consume and process ``FocusGroupCmd``s instead of letting them surface.
	public func updateFocused(msg: any RBMessage) -> (any Command)? {
		let cmd = items[focusedItem].update(msg: msg)
		if let cmd = cmd as? FocusGroupCmd {
			switch cmd {
				case .focusNext:
					focusNext()
				case .focusPrev:
					focusPrev()
			}
			return nil
		}
		
		return cmd
	}
	
	
	public func getNextIndex() -> Int {
		// ensure at least one non-disabled item is present
		precondition(items.contains(where: { !$0.disabled } ), "Precondition Violated: FocusGroup must have at least one non-disabled item to give focus to.\n\r(Serious developer issue. Prevented infinite loop)")
		
		var candidate = (focusedItem + 1) % items.count // increment with wraparound
		
		while items[candidate].disabled { // skip over disabled items
			candidate = (candidate + 1) % items.count
		}
		
		return candidate
	}
	
	
	public func getPrevIndex() -> Int {
		// ensure at least one non-disabled item is present
		precondition(items.contains(where: { !$0.disabled } ), "Precondition Violated: FocusGroup must have at least one non-disabled item to give focus to.\n\r(Serious developer issue. Prevented infinite loop)")
		
		var candidate = (focusedItem + items.count - 1) % items.count // increment with wraparound
		
		while items[candidate].disabled { // skip over disabled items
			candidate = (candidate + items.count - 1) % items.count
		}
		
		return candidate
	}
}
