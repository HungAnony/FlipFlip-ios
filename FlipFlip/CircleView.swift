//
//  CircleView.swift
//  FlipFlip
//
//  Created by Ta Huy Hung on 3/6/20.
//  Copyright © 2020 Class iOS. All rights reserved.
//

import Foundation
import UIKit

class CircleView : UIView{
    private var startAngle = -CGFloat.pi/2.0
    private let lineWidth : CGFloat = 12.0
    private let _360radian = 2*CGFloat.pi
    private var endAngle = -CGFloat.pi/2.0 + 2*CGFloat.pi
    private var totalSeconds : Double = 1*60
    private var remainingSeconds : Double = 1*60
    private var gradient : CAGradientLayer? = nil
    private var animationComplete = false
    private var lastUpdateTime = CACurrentMediaTime()
    
    override func draw(_ rect: CGRect) {
        let centerPoint = CGPoint.init(x: rect.width/2.0, y: rect.height/2.0)
        let radius = (rect.width - lineWidth)/2.0
        drawCircle(centerPoint, CGFloat(radius))
    }
    
    func drawCircle(_ centerPoint : CGPoint,_ radius : CGFloat) {
        gradient?.removeFromSuperlayer()
        let path: UIBezierPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = CGFloat(lineWidth)
        
        gradient = CAGradientLayer()
        gradient?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradient?.colors = [cgColor(red: 253, green: 109, blue: 118),
                           cgColor(red: 253, green: 109, blue: 118)]
        gradient?.startPoint = CGPoint(x: 0, y: 0)
        gradient?.endPoint = CGPoint(x: 1, y: 0)
        gradient?.mask = shapeLayer
        
        self.layer.addSublayer(gradient!)
    }
    
    func cgColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
      return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor
    }
    
    func startAnimationCountdown(seconds : Int) {
        self.totalSeconds = Double.init(seconds)
        self.remainingSeconds = Double.init(seconds)
        animationComplete = false
        smoothTimer()
    }
    
    private func smoothTimer() {
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .main, forMode: .default)
        updateValues()
    }
    
    @objc private func animationDidUpdate(displayLink: CADisplayLink) {
        if(!animationComplete) {
            let now = CACurrentMediaTime()
            let interval = (now - lastUpdateTime)/Double.init(totalSeconds)
            self.countDown(factor: interval)
            animationComplete = interval >= 1.0
        }
    }
    
    func updateValues() {
        self.countDown(factor: 0)
        lastUpdateTime = CACurrentMediaTime()
    }
    
    
    func countDown(factor : Double) {
        self.remainingSeconds -= factor
        self.endAngle = startAngle + _360radian * (1.0 - CGFloat.init(factor))
        self.setNeedsDisplay()
    }
}
