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
            addRing2(sender)
        case false:
            deselect(sender)
        }
    }

    func addRing(sender: Switch) {
        for index in 0..<SwitchIndex.maxCountForLevel(sender.index.level+1) {
            RefreshQueue.add (index * 10) {
                self.addSwitch(SwitchIndex(level: sender.index.level+1, offset: index))
            }
        }
    }

    func addRing2(sender: Switch) {
        let innerIndex = sender.index
        let startingIndex = sender.index.translateToLevel(sender.index.level+1)
        let count = SwitchIndex.maxCountForLevel(startingIndex.level) / 2

        let remove = self.switches[startingIndex] != nil

        for i in 0...count {
            RefreshQueue.add (i * 2) {
                if (remove) {
                    if let sw = self.switches[startingIndex.indexByAddingOffset(i)] {
                        sw.removeFromSuperview()
                        self.switches.removeValueForKey(sw.index)
                    }
                    if let sw = self.switches[startingIndex.indexByAddingOffset(-i)] {
                        sw.removeFromSuperview()
                        self.switches.removeValueForKey(sw.index)
                    }
                } else {
                    self.addSwitch(startingIndex.indexByAddingOffset(i))
                    self.addSwitch(startingIndex.indexByAddingOffset(-i))
                }

                if sender.index.level > 0 {
                    if let sw = self.switches[innerIndex.indexByAddingOffset(i)] {
                        sw.setOn(true, animated: true)
                    }
                    if let sw = self.switches[innerIndex.indexByAddingOffset(-i)] {
                        sw.setOn(true, animated: true)
                    }
                }
            }
        }
    }

    func deselect(sender: Switch) {
        let innerIndex = sender.index
        let startingIndex = sender.index.translateToLevel(sender.index.level+1)
        let count = SwitchIndex.maxCountForLevel(startingIndex.level) / 2

        let remove = self.switches[startingIndex] != nil

        for i in 0...count {
            RefreshQueue.add (i * 2) {
                if (remove) {
                    if let sw = self.switches[startingIndex.indexByAddingOffset(i)] {
                        sw.removeFromSuperview()
                        self.switches.removeValueForKey(sw.index)
                    }
                    if let sw = self.switches[startingIndex.indexByAddingOffset(-i)] {
                        sw.removeFromSuperview()
                        self.switches.removeValueForKey(sw.index)
                    }
                } else {
                    self.addSwitch(startingIndex.indexByAddingOffset(i))
                    self.addSwitch(startingIndex.indexByAddingOffset(-i))
                }
                if sender.index.level > 0 {
                    if let sw = self.switches[innerIndex.indexByAddingOffset(i)] {
                        sw.setOn(false, animated: true)
                    }
                    if let sw = self.switches[innerIndex.indexByAddingOffset(-i)] {
                        sw.setOn(false, animated: true)
                    }
                }
            }
        }
    }

    func addSwitch(index: SwitchIndex) -> Switch? {
        guard switches[index] == nil else { return nil }
        let newSwitch = Switch.init(index: index, center: mainSwitch.center)
        newSwitch.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        switches[index] = newSwitch
        view.addSubview(newSwitch)

        newSwitch.on = true
        RefreshQueue.add(12) {
            newSwitch.setOn(false, animated: true)
        }

        return newSwitch
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}