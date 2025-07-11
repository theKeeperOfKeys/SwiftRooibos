//
//  MessageBroker.swift
//  Rooibos
//
//  Created by Claude AI on 2025-07-08.
//

import Foundation

public actor MessageBroker {
	// Author: Claude AI
	private var messageQueue: [RBMessage] = []
	private var continuation: AsyncStream<RBMessage>.Continuation?
	
	public func send(_ message: RBMessage) {
		messageQueue.append(message)
		continuation?.yield(message)
	}
	
	public func createStream() -> AsyncStream<RBMessage> {
		AsyncStream { continuation in
			self.continuation = continuation
			
			// Send any queued messages
			Task {
				self.flushQueue(to: continuation)
			}
		}
	}
	
	private func flushQueue(to continuation: AsyncStream<RBMessage>.Continuation) {
		for message in messageQueue {
			continuation.yield(message)
		}
		messageQueue.removeAll()
	}
}
