//
//  main.swift
//  Rooibos
//
//  Created by Kai Driessen on 2025-07-01.
//

import Foundation
import Rooibos

let program = Program(model: ExampleModel())
do {
	try await program.run()
} catch {
	print("Error thrown. Cannot continue")
}
