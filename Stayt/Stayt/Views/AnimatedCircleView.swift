//
//  AnimatedCircleView.swift
//  Stayt
//
//  Created by Владимир Мельников on 05/04/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class AnimatedCircleView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: -CGFloat(Double.pi / 2), endAngle: CGFloat(3 * Double.pi / 2.0), clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = Colors.mainActiveColor.cgColor
        circleLayer.lineWidth = 5.0;
        
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }
    
    func animateCircle(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        circleLayer.strokeEnd = 1.0
        
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    func stopAnimation() {
        
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
    }
    
    func resumeAnimation() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = frame.size.width / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1.0
    }
}
