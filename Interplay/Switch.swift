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

    required init(index: SwitchIndex, root: Switch) {
        self.index = index
        super.init(frame: CGRectZero)

        center = root.center
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
        onTintColor = UIColor(red: CGFloat(index.level)/10, green: 0.8, blue: 0.8 - CGFloat(index.level)/10, alpha: 1.0)
        tintColor = UIColor(red: CGFloat(index.level)/10, green: 0.8, blue: 0.8 - CGFloat(index.level)/10, alpha: 1.0)
    }

}


struct SwitchIndex: Hashable {

    let level: Int
    let offset: Int

    var hashValue: Int {
        return level * 10000 + offset
    }

    var angle: CGFloat {
        return CGFloat(offset) * SwitchIndex.paddedRadiansForLevel(level)
    }

    static func radiansForLevel(level: Int) -> CGFloat {
        let radius = (CGFloat(level)-0.5) * Switch.size.width + (Switch.size.height / 2.0)
        let circumfrence = 2 * CGFloat(M_PI) * radius
        return (Switch.size.height / circumfrence) * CGFloat(M_PI) * 2
    }

    static func paddedRadiansForLevel(level: Int) -> CGFloat {
        return CGFloat(M_PI * 2) / CGFloat(maxCountForLevel(level))
    }

    static func maxCountForLevel(level: Int) -> Int {
        return Int(CGFloat(M_PI * 2) / radiansForLevel(level))
    }

    func translateToLevel(toLevel: Int) -> SwitchIndex {
        let radians = SwitchIndex.paddedRadiansForLevel(toLevel)
        return SwitchIndex(level: toLevel, offset: Int(round((angle / radians))))
    }

    func indexByAddingOffset(offsetChange: Int) -> SwitchIndex {
        var newOffset = offset + offsetChange

        while newOffset < 0 {
            newOffset += SwitchIndex.maxCountForLevel(level)
        }

        newOffset = newOffset % SwitchIndex.maxCountForLevel(level)
        return SwitchIndex(level: level, offset: newOffset)
    }

}

func ==(lhs: SwitchIndex, rhs: SwitchIndex) -> Bool {
    return lhs.hashValue == rhs.hashValue
}