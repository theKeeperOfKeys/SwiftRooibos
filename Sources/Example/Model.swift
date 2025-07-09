//
//  Model.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-01.
//


import Foundation
import Rooibos


class ExampleModel: Model {
	var frameNo = 0
	var tickNo = 0
	var processFrameNo = 0
	
	let radioButtonGroup: ExclusiveGroup = ExclusiveGroup()
	lazy var focusGroup = FocusGroup(items:
		[checkA, switchA, switchB, spinnerA, lineEditA, lineEditB] + radioButtons + [button1, button2]
	)
	
	var tick = false
	
	let checkA = Toggle()
	let switchA = Toggle(style: .switch)
	let switchB = Toggle(style: .switch)
	let spinnerA = Spinner()
	let lineEditA = LineEdit(label: "Text Edit", placeholder: "Any Unicode")
	let lineEditB = LineEdit(label: "Strict Edit", placeholder: "Lowercase Alphanumerics Only", allowOnly: .alphanumerics, dontAllow: .uppercaseLetters)
	lazy var button1 = Button(label: "Reset Stats") { [weak self] in // not sure if there's a better way to do this...
		self?.resetStats()
		return nil
	}
	let button2 = Button(label: "Change Views") {
		return AppCmd.changeModel(SecondModel())
	}

	let radioButtons: [Toggle]

	let options = [
		"Disable the Second Switch",
		"Disable the Check Box",
		"Disable the First Line Edit",
		"Do nothing",
	]
	
	var backgroundTask: Task<Void, Never>? = nil
	
	func startup() -> (any Command)? { // start some background task
		backgroundTask = Task {
			while !Task.isCancelled {
				await Program.messageBroker.send(Tick()) // this task just sends ticks back to the program, telling it to update.
				sleep(1)
			}
		}
		
		return nil
	}
	
	
	public init() {
		self.radioButtons = (0..<options.count).map { _ in Toggle(uncheckWhenDisabled: true, style: .radio) } // create one button per option.
		for button in radioButtons {
			radioButtonGroup.add(button)
		}
	}
	
	
	deinit {
		backgroundTask?.cancel()
	}
	
	
	func resetStats() {
		frameNo = 0
		processFrameNo = 0
		tickNo = 0
	}
	
	
	func update(msg: any RBMessage) -> Command? {
		frameNo += 1

		switch msg {
			case let msg as KeyPress: switch msg {
				case .escape:
					return AppCmd.quit
				
				case .up, .pageUp:
					focusGroup.focusPrev()
					return nil
				
				case .down, .pageDown, .tab:
					focusGroup.focusNext()
					return nil
				
				default: break
			}
			case _ as Tick: // received a tick?
				tick.toggle()
				tickNo += 1
				return nil
			default: break
		}
		
		
		let cmd = focusGroup.updateFocused(msg: msg) // update the focused element
		
		radioButtons[0].disabled = radioButtonGroup.checkedIndex == 2
		
		for button in radioButtons {
			button.disabled = switchA.on
		}
		
		switchA.disabled = checkA.on
		switchB.disabled = radioButtonGroup.checkedIndex == 0
		checkA.disabled = radioButtonGroup.checkedIndex == 1
		spinnerA.disabled = switchB.on
		lineEditA.disabled = radioButtonGroup.checkedIndex == 2
		
		
		processFrameNo += 1
		return cmd
	}
	
	
	public var body: String {
		var view = "Example Model. Press [esc] to quit.".line
		
		view += "STATIC:".line
		view += checkA.body + "Disable Switch".line
		view += switchA.body + "Disable Radios".line
		view += switchB.body + "Disable Spinner".line
		view += "\(Fmt.reset)Spinner:" + spinnerA.body.line
		view += lineEditA.body.line
		view += lineEditB.body.line
		view += Fmt.reset.str.line
		view += (tick ? "tick" : "tock").line

		view += "VARADIC:".line
		for (i, radioButton) in radioButtons.enumerated() {
			view += radioButton.body + options[i].line
		}
		view += Fmt.reset.str.line // remove grey from disabled radio buttons
		
		view += "BUTTONS: ".line
		//view += button1.body.line
		view += button2.body.line.line
	
		view += "INFO:".line
		view += "frame number: \(frameNo)".line
		view += "process frame number: \(processFrameNo)".line
		view += "Tick number: \(tickNo)".line
		view += "focused is: \(focusGroup.focusedItem)".line
		view += "chosen radiobutton: \(radioButtonGroup.checkedIndex?.description ?? "nil")".line
		
		return view
	}
}


class SecondModel: Model {
	func update(msg: any RBMessage) -> (any Command)? {
		switch msg {
			case let msg as KeyPress:
				switch msg {
					case .escape:
						return AppCmd.changeModel(ExampleModel())
					default: return nil
				}
			default: return nil
		}
	}
	
	var body: String {
		return "Second Model.".line + "Very empty here...".line + "Press [esc] to go back.".line
	}
}
