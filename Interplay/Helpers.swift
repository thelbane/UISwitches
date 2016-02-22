//
//  Helpers.swift
//  Interplay
//
//  Created by Lee Fastenau on 2/21/16.
//  Copyright © 2016 ioyu. All rights reserved.
//

import Foundation

func delay(delay: NSTimeInterval, closure: () -> Void) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
        closure()
    }
}