//
//  UI.swift
//  HW
//
//  Created by Adrian Nenu on 07/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit


class Btn: UIButton {
    init(title: String, position: CGPoint, type: String = "default") {
        super.init(frame: CGRect(x: position.x, y: position.y, width: CGFloat(title.characters.count * 7 + 20), height: 30))
        self.titleLabel?.font = UIFont (name: "Josefin Sans", size: 20)
        setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centerInParent() {
        self.frame = CGRect(x: self.superview!.frame.width / 2 - self.frame.width / 2, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
    }
    
}

class FormUITextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 13, right: 5);
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textColor = UIColor(red:0.00, green:0.49, blue:0.86, alpha:1.0)
        self.font = UIFont (name: "Josefin Sans", size: 18)
        
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red:0.00, green:0.49, blue:0.86, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        self.textAlignment = .center
        
    }
    
    
    func setPlaceholder(string: String) {
        self.attributedPlaceholder = NSAttributedString(string: string,
                                                        attributes: [NSForegroundColorAttributeName: self.textColor!])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
