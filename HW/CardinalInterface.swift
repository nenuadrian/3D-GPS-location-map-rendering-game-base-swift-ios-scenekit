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
        super.init(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 40 ))
        GUIMaster.view.addSubview(self)
        backgroundColor = UIColor.black

        scrollView = UIScrollView(frame: CGRect(x: 15, y: 15, width: frame.width - 30, height: frame.height - 30))
        scrollView.backgroundColor = UIColor.red
        
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
