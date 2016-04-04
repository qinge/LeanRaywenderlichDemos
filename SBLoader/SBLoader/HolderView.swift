//
//  HolderView.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-17.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
  func animateLabel()
}

class HolderView: UIView {
    
    let ovalLayer = OvalLayer()
    let triangleLayer = TriangleLayer()
    
    let redRectangleLayer = RectangleLayer()
    let blueRectangleLayer = RectangleLayer()
    
    let arcLayer = ArcLayer()

  var parentFrame :CGRect = CGRectZero
  weak var delegate:HolderViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.clear
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
    
    
    /**
     添加圆形图层 并实现从小变大动画
     */
    func addOval(){
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
        
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "wobbleOval", userInfo: nil, repeats: false)
    }
    
    /**
     添加三角形图层 并实现心跳动画
     */
    func wobbleOval(){
        
        layer.addSublayer(triangleLayer)
        
        ovalLayer.wobble()
        
        NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: "drawAnimatedTriangle", userInfo: nil, repeats: false)
    }
    
    /**
     实现 三个角冒出动画
     */
    func drawAnimatedTriangle(){
        triangleLayer.animate()
        NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: "spinAndTransform", userInfo: nil, repeats: false)
    }
    
    
    /**
     旋转三角 并将圆形图层变小
     */
    func spinAndTransform() {
        // 1
        layer.anchorPoint = CGPointMake(0.5, 0.6)
        
        // 2
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI * 2.0)
        rotationAnimation.duration = 0.45
        rotationAnimation.removedOnCompletion = true
        layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
        // 3 
        ovalLayer.contract()
        
        NSTimer.scheduledTimerWithTimeInterval(0.45, target: self,
            selector: "drawRedAnimatedRectangle",
            userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.65, target: self,
            selector: "drawBlueAnimatedRectangle",
            userInfo: nil, repeats: false)
    }
    
    
    /**
     画边框动画
     */
    func drawRedAnimatedRectangle() {
        layer.addSublayer(redRectangleLayer)
        redRectangleLayer.animateStrokeWithColor(Colors.red)
    }
    
    func drawBlueAnimatedRectangle() {
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.animateStrokeWithColor(Colors.blue)
        
        NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: "drawArc",
            userInfo: nil, repeats: false)
    }
    
    /**
     灌水动画
     */
    func drawArc() {
        layer.addSublayer(arcLayer)
        arcLayer.animate()
        
        NSTimer.scheduledTimerWithTimeInterval(0.90, target: self, selector: "expandView",
            userInfo: nil, repeats: false)
    }
    
    /**
     变大全屏动画
     */
    func expandView() {
        // 1
        backgroundColor = Colors.blue
        
        // 2
        frame = CGRectMake(frame.origin.x - blueRectangleLayer.lineWidth,
            frame.origin.y - blueRectangleLayer.lineWidth,
            frame.size.width + blueRectangleLayer.lineWidth * 2,
            frame.size.height + blueRectangleLayer.lineWidth * 2)
        
        // 3
        layer.sublayers = nil
        
        // 4
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.frame = self.parentFrame
            }, completion: { finished in
                self.addLabel()
        })
    }

    
    func addLabel() {
        delegate?.animateLabel()
    }
}
