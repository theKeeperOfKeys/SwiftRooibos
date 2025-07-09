//
//  Rooibos.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-06-24.
//

import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public actor Program {
	static var originalTerminal: termios? = nil
	public static let messageBroker = MessageBroker()
	
	let inputReader: InputReader
	var currentModel: Model
	var isRunning = false
	//var backgroundTasks: [Task<Void, Never>] = []
	
	
	public init(model: Model) {
		currentModel = model
		currentModel.messageBroker = Program.messageBroker
		inputReader = InputReader()
	}
	
	
	public func run() async throws {
		isRunning = true
		
		var original = try setupTerminal()
		
		[SIGTRAP, SIGINT, SIGSEGV, SIGABRT, SIGBUS, SIGFPE, SIGILL].forEach { sig in
			signal(sig) { signal in
				crashHandler(signal: signal) // assign crash handler for each of these signals
			}
		}
		
		
		defer {
			restoreTerminal(to: &original)
		}
		
		try await startMainLoop()
	}
	
	
	
	func startMainLoop() async throws {
		if let startupCommand = currentModel.startup() {
			handleCommand(startupCommand)
		}
				
		let messageStream = await Program.messageBroker.createStream()
		
		let keyboardListener = Task {
			while !Task.isCancelled {
				if let keyPress = inputReader.getKeyPress() {
					await Program.messageBroker.send(keyPress)
				}
				try? await Task.sleep(nanoseconds: 1_000_000)
			}
		}
		
		defer {
			keyboardListener.cancel()
			//backgroundTasks.forEach { $0.cancel() }
		}
			
		render() // initial render
		for await message in messageStream {
			guard isRunning else { break }
			
			if let command = currentModel.update(msg: message) {
				handleCommand(command)
			}
			
			render()
			
			guard isRunning else { break }
		}
	}
	
	
	func render() {
		clear()
		print(currentModel.body, terminator: "\n\r")
		fflush(stdout)
	}
	
	
	func handleCommand(_ command: Command) {
		switch command {
		case let command as AppCmd:
			switch command {
				case .quit:
					isRunning = false
					
				case .changeModel(let newModel):
					currentModel = newModel
			}
		default:
			fatalError("Non-app command was surfaced to top level.")
		}
	}
	
	
	func setupTerminal() throws -> termios {
//		var originalTermSetting = termios()
//		
//		if unsafeGlobalOriginalTerminal == nil {
//			unsafeGlobalOriginalTerminal = originalTermSetting
//		}
		
		
		guard isatty(STDIN_FILENO) != 0 else {
			throw RawModeError.notATerminal
		}

		var originalTermSetting = termios()
		guard tcgetattr(STDIN_FILENO, &originalTermSetting) >= 0 else {
			throw RawModeError.failedToGetTerminalSetting
		}
		
		
		if Program.originalTerminal == nil {
			Program.originalTerminal = originalTermSetting
		}


		var raw = originalTermSetting
		raw.c_iflag &= ~(UInt(BRKINT) | UInt(ICRNL) | UInt(INPCK) | UInt(ISTRIP) | UInt(IXON))
		raw.c_oflag &= ~(UInt(OPOST))
		raw.c_cflag |= UInt(CS8)
		raw.c_lflag &= ~(UInt(ECHO) | UInt(ICANON) | UInt(IEXTEN) | UInt(ISIG))
		raw.c_cc.16 = 1 // VMIN
		raw.c_cc.17 = 0 // VTIME

		guard tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw) >= 0 else {
			throw RawModeError.failedToSetTerminalSetting
		}
		
		enterAltBuffer()
		
		#if !DEBUG
		hideCursor()
		#endif

		return originalTermSetting
	}
	
	
	func restoreTerminal(to originalTerm: inout termios) {
		tcsetattr(STDIN_FILENO, TCSAFLUSH, &originalTerm)
		exitAltBuffer()
		showCursor()
	}
}
