//
//  SwitchIndex.swift
//  Interplay
//
//  Created by Lee Fastenau on 2/24/16.
//  Copyright © 2016 ioyu. All rights reserved.
//

import UIKit

struct SwitchIndex: Hashable {

    let level: Int
    let offset: Int

    var hashValue: Int {
        return level * 10000 + offset
    }

    var angle: CGFloat {
        return CGFloat(offset) * SwitchIndex.paddedRadiansForLevel(level)
    }

    var maxCount: Int {
        return SwitchIndex.maxCountForLevel(self.level)
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