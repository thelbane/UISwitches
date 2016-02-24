//
//  RefreshQueue.swift
//  Interplay
//
//  Created by Lee Fastenau on 2/23/16.
//  Copyright © 2016 ioyu. All rights reserved.
//

import UIKit

public class RefreshQueue {

    public static let shared = RefreshQueue()
    public typealias Action = () -> Void

    private typealias QueueItem = (expiry: Int, action: Action, id: Int)

    private var itemId = 0
    private var queue = [QueueItem]()
    private var displayLink: CADisplayLink!
    private var currentFrame: Int { return Int(CACurrentMediaTime() * 60) }

    public static func add(frameInterval: Int, action: Action) {
        shared.add(frameInterval, action: action)
    }

    public func add(frameInterval: Int, action: Action) {
        queue.append((expiry: currentFrame + frameInterval, action: action, id: itemId++))
        startDisplayLink()
    }

    private func startDisplayLink() {
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: "displayLinkTick:")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }

    private func stopDisplayLink() {
        guard displayLink != nil else { return }
        displayLink.invalidate()
        displayLink = nil
    }

    @objc private func displayLinkTick(sender: CADisplayLink) {
        let executables = queue.filter { item -> Bool in
            return item.expiry <= currentFrame
        }

        for item in executables {
            item.action()
            queue.removeAtIndex(queue.indexOf({ inItem -> Bool in
                return inItem.id == item.id
            })!)
        }

        if queue.count == 0 {
            stopDisplayLink()
        }
    }
    
}