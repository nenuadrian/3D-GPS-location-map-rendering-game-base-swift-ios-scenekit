//
//  File.swift
//  HackerC
//
//  Created by Adrian Nenu on 10/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TaskView: UIView, UIGestureRecognizerDelegate {
    let task: Task
    let progressLine: CAShapeLayer
    
    init(task: Task) {
        self.task = task
        let index = TasksManager.tasks.count
        progressLine = CAShapeLayer()
        super.init(frame: CGRect(x: Int(UIScreen.main.bounds.width - 70), y: 75 * (index + 1), width: 60, height: 60))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        
        
        
        // set up some values to use in the curve
        let ovalStartAngle = CGFloat(90.01 * Float.pi/180)
        let ovalEndAngle = CGFloat(90 * Float.pi/180)
        let ovalRect = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        // create the bezier path
        let ovalPath = UIBezierPath()
        
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY),
                                  radius: ovalRect.width / 2,
                                  startAngle: ovalStartAngle,
                                  endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        progressLine.path = ovalPath.cgPath
        progressLine.strokeColor = UIColor.white.cgColor
        progressLine.fillColor = UIColor.clear.cgColor
        progressLine.lineWidth = 4.0
        progressLine.lineCap = kCALineCapRound
        
        // add the curve to the screen
        layer.addSublayer(progressLine)
        
        // add the animation
        
        DispatchQueue.main.async {
            Cardinal.myInstance.view.addSubview(self)
        }
    }
    
    func set(progress: CGFloat) {
        DispatchQueue.main.async {
            self.progressLine.strokeEnd = progress
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if task.state == .DONE_SERVER {
            task.claim()
        } else {
            print("not done server")
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
