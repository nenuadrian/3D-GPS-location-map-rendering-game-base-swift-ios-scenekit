//
//  CardinalInterface.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit


class CardinalInterface: UIView {
    private var scrollView: UIScrollView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
        GUIMaster.myInstance.view.addSubview(self)
        backgroundColor = UIColor.black
        alpha = 0.8

        scrollView = UIScrollView(frame: CGRect(x: 40, y: 40, width: frame.width - 80, height: frame.height - 80))
        
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview(v: UIView) {
        self.scrollView.addSubview(v)
       /* var contentRect = CGRect.zero
        for view in self.scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollView.contentSize = CGSize(width: 1000, height: 1000)
        print(self.scrollView.contentSize)*/
    }
    
    @objc func close() {
        removeFromSuperview()
        scrollView.removeFromSuperview()
    }
}
