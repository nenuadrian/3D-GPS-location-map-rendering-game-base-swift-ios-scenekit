//
//  CardinalInterface.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit


class CardinalInterface: UIViewController {
    private var scrollView: UIScrollView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //Cardinal.myInstance.view.addSubview(self)

        view.backgroundColor = UIColor(patternImage: UIImage(named: "padded")!)
        view.alpha = 0.97

        scrollView = UIScrollView(frame: CGRect(x: 40, y: 40, width: view.frame.width - 80, height: view.frame.height - 120))
        
        view.addSubview(scrollView)
        
        let done = Btn(title: "OK", position: CGPoint(x: 40, y: view.frame.height - 70))
        done.addTarget(self, action: #selector(doneCall), for: .touchDown)
        view.addSubview(done)
        done.centerInParent()
        
        Cardinal.myInstance.addChildViewController(self)
        Cardinal.myInstance.view.addSubview(self.view)
        self.didMove(toParentViewController: Cardinal.myInstance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doneCall(_ sender: AnyObject?) {
        close()
    }
    
    func addSubview(v: UIView) {
        self.scrollView.addSubview(v)
    }
    
    @objc func close() {
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
