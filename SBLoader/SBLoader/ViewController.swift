//
//  ViewController.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-16.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//
//  https://www.raywenderlich.com/102590/how-to-create-a-complex-loading-animation-in-swift


import UIKit

class ViewController: UIViewController, HolderViewDelegate {
  
  var holderView = HolderView(frame: CGRectZero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    addHolderView()
    holderView.addOval()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func addHolderView() {
    let boxSize: CGFloat = 100.0
    holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                              y: view.bounds.height / 2 - boxSize / 2,
                              width: boxSize,
                              height: boxSize)
    holderView.parentFrame = view.frame
    holderView.delegate = self
    view.addSubview(holderView)
  }
  
    /**
      文字 s 动画
     */
  func animateLabel() {
    // 1
    holderView.removeFromSuperview()
    view.backgroundColor = Colors.blue
    
    // 2
    let label: UILabel = UILabel(frame: view.frame)
    label.textColor = Colors.white
    label.font = UIFont(name: "HelveticaNeue-Thin", size: 170.0)
    label.textAlignment = NSTextAlignment.Center
    label.text = "S"
    label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25)
    view.addSubview(label)
    
    // 3
    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
        animations: ({
            label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
        }), completion: { finished in
            self.addButton()
    })
  }
  
  func addButton() {
    let button = UIButton()
    button.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
    button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    view.addSubview(button)
  }
  
  func buttonPressed(sender: UIButton!) {
    view.backgroundColor = Colors.white
    view.subviews.map({ $0.removeFromSuperview() })
    holderView = HolderView(frame: CGRectZero)
    addHolderView()
  }
}

