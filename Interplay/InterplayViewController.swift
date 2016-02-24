//
//  InterplayViewController.swift
//  Interplay
//
//  Created by Lee Fastenau on 2/21/16.
//  Copyright © 2016 ioyu. All rights reserved.
//

import UIKit

class InterplayViewController: UIViewController {

    var switches = [SwitchIndex: Switch]()

    @IBOutlet weak var mainSwitch: Switch!

    @IBAction func valueChanged(sender: Switch) {
        switch sender.on {
        case true:
            toggleRing(sender)
        case false:
            toggleRing(sender)
        }
    }

    func toggleRing(sender: Switch) {
        let switchingOn = sender.on
        let innerIndex = sender.index
        let outerIndex = innerIndex.translateToLevel(innerIndex.level+1)
        let innerCount = innerIndex.maxCount
        let outerCount = outerIndex.maxCount

        for i in 0..<outerCount {
            RefreshQueue.add(i) {
                if switchingOn {
                    self.addSwitch(outerIndex.indexByAddingOffset(i.stagger))
                } else {
                    self.removeSwitch(outerIndex.indexByAddingOffset(i.stagger))
                }
            }
        }

        guard innerCount > 0 else { return }
        for i in 0..<innerCount {
            let frameInterval: Int = Int(Float(outerCount) * (Float(i) / Float(innerCount)))
            RefreshQueue.add(frameInterval) {
                self.switches[innerIndex.indexByAddingOffset(i.stagger)]?.setOn(switchingOn, animated: true)
            }
        }
    }

    func addSwitch(index: SwitchIndex) {
        guard switches[index] == nil else { return }
        let newSwitch = Switch.init(index: index, center: mainSwitch.center)
        newSwitch.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        switches[index] = newSwitch
        view.addSubview(newSwitch)

        newSwitch.on = true
        RefreshQueue.add(12) {
            newSwitch.setOn(false, animated: true)
        }
    }

    func removeSwitch(index: SwitchIndex) {
        switches[index]?.removeFromSuperview()
        switches.removeValueForKey(index)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}