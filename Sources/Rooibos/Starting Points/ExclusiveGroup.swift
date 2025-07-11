//
//  ExclusiveGroup.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-04.
//

import Foundation



public class ExclusiveGroup {
	var items: [Toggle] = []
	
	public var checkedIndex: Int? {
		items.firstIndex { $0.on }
	}
	
	public init() {}
	
	
	public func add(_ toggle: Toggle) {
		items.append(toggle)
		toggle.exclusiveGroup = self
	}
	
	
	public func toggle(_ selectedToggle: Toggle) {
		// Turn off all other toggles that are on.
		for toggle in items where toggle !== selectedToggle {
			toggle.on = false
		}
		selectedToggle.on.toggle()
	}
}
