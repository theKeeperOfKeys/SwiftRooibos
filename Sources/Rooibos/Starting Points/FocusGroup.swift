//
//  File.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-01.
//

import Foundation


public class FocusGroup {
	public var items: [any Focusable & Model]
	public private(set) var focusedItem: Int = 0
	
	
	public init(items: [any Focusable & Model]) {
		precondition(!items.isEmpty, "Precondition Violated: FocusGroup must have at least one focusable item.\n(Serious developer issue.)")
		self.items = items
		//await self.items[focusedItem].focus()
	}
	
	
	public func focusNext() {
		let newFocusIdx = getNextIndex()
//		await items[focusedItem].unfocus()
//		await items[newFocusIdx].focus()
		items[focusedItem].focused = false
		items[newFocusIdx].focused = true
		focusedItem = newFocusIdx
	}
	
	
	public func focusPrev() {
		let newFocusIdx = getPrevIndex()
//		await items[focusedItem].unfocus()
//		await items[newFocusIdx].focus()
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
	/// - Returns: Command returned.
	public func updateFocused(msg: any RBMessage) -> (any Command)? {
		items[focusedItem].update(msg: msg)
	}
	
	
	public func getNextIndex() -> Int {
		// ensure at least one non-disabled item is present
		
//		precondition(items.contains(where: { !$0.disabled } ), "Precondition Violated: FocusGroup must have at least one non-disabled item to give focus to.\n(Serious developer issue. Prevented infinite loop)")
		
		var candidate = (focusedItem + 1) % items.count // increment with wraparound
		
		while items[candidate].disabled { // skip over disabled items
			candidate = (candidate + 1) % items.count
		}
		
		return candidate
	}
	
	
	public func getPrevIndex() -> Int {
		// ensure at least one non-disabled item is present
//		guard items.contains(where: { !$0.disabled } ) else {
//			return 0
//		}
		
		var candidate = (focusedItem + items.count - 1) % items.count // increment with wraparound
		
		while items[candidate].disabled { // skip over disabled items
			candidate = (candidate + items.count - 1) % items.count
		}
		
		return candidate
	}
}
	//
	//	public func updateFocused(msg: any TSMessage) -> Command? {
	//		return items[focusedItem].update(msg: msg)
	//	}
	//
	//
	//
	//
	//	public func updateAll(msg: any TSMessage) -> [Command] {
	//		var collectedCommands: [Command] = []
	//
	//		for i in items.indices {
	//			if let command = items[i].update(msg: msg) {
	//				collectedCommands.append(command)
	//			}
	//		}
	//
	//		return collectedCommands
	//	}
	//	

