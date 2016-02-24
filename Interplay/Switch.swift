//
//  Switch.swift
//  Interplay
//
//  Created by Lee Fastenau on 2/21/16.
//  Copyright © 2016 ioyu. All rights reserved.
//

import UIKit

class Switch: UISwitch {

    let index: SwitchIndex

    static let size: CGSize = {
        let tempSwitch = UISwitch()
        return tempSwitch.frame.size
    }()

    required init(index: SwitchIndex, center: CGPoint) {
        self.index = index
        super.init(frame: CGRectZero)

        self.center = center
        layer.anchorPoint = CGPointMake(-CGFloat(index.level)+0.5,0.5)
        transform = CGAffineTransformMakeRotation(index.angle)
        updateTintColor()
    }

    required init?(coder aDecoder: NSCoder) {
        index = SwitchIndex(level: 0, offset: 0)
        super.init(coder: aDecoder)
        updateTintColor()
    }

    func updateTintColor() {
        let hue = 1.0 - CGFloat(index.level) / 20
        let color = UIColor(hue: hue, saturation: 0.3, brightness: 1.0, alpha: 1.0)
        onTintColor = color
        tintColor = color
    }

}