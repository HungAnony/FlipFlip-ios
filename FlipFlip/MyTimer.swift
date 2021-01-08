//
//  MyTimer.swift
//  FlipFlip
//
//  Created by Ta Huy Hung on 3/6/20.
//  Copyright © 2020 Class iOS. All rights reserved.
//

import Foundation
import UIKit

class MyTimer : NSObject{
    private var interval : TimeInterval
    private var target : Any
    private var selector : Selector
    private var repeate : Bool
    private var stopTimer : Bool = false
    
    private init(interval : TimeInterval, target : Any, selector : Selector, repeate : Bool) {
        self.interval = interval
        self.target = target
        self.selector = selector
        self.repeate = repeate
    }
    
    private func startTimer() {
        DispatchQueue.global(qos: .default).async {
            repeat{
                sleep(UInt32(self.interval))
                DispatchQueue.main.sync {
                    let instance = self.target as! NSObject
                    instance.perform(self.selector, with: self)
                }
            }while(!self.stopTimer || !self.repeate)
        }
    }
    
    func invalidate() {
        self.stopTimer = true
    }
    
    class func scheduledTimer(interval : TimeInterval, target : Any, selector : Selector, repeate : Bool) -> MyTimer {
        let timer = MyTimer(interval: interval, target: target, selector: selector, repeate: repeate)
        timer.startTimer()
        return timer
    }
}

