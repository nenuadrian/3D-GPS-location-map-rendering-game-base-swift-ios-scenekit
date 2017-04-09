//
//  UI.swift
//  HW
//
//  Created by Adrian Nenu on 07/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func centerInParent() {
        frame = CGRect(x: superview!.frame.width / 2 - frame.width / 2, y: frame.origin.y, width: frame.width, height: frame.height)
    }
    
    func rightInParent() {
        frame = CGRect(x: superview!.frame.width - frame.width, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

extension UIButton {
    func setFont(size: CGFloat) {
        titleLabel?.font = titleLabel?.font.withSize(size)
        sizeToFit()
    }
}

extension UILabel {
    func setFont(size: CGFloat) {
        font = font.withSize(size)
    }
}

class Label: UILabel {
    init(text: String, frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont (name: "Josefin Sans", size: 15)
        self.textColor = UIColor.white
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Btn: UIButton {
    init(title: String, position: CGPoint, type: String = "default") {
        super.init(frame: CGRect(x: position.x, y: position.y, width: UIScreen.main.bounds.width, height: 30))
        self.titleLabel?.font = UIFont (name: "Josefin Sans", size: 20)
        setTitle(title, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

class CardinalInterface: UIViewController {
    let scrollView: UIScrollView
    let closeBtn: Btn
    static let subviewWidth = UIScreen.main.bounds.width - 60 - 5
    
    init() {
        let size = UIScreen.main.bounds
        scrollView = UIScrollView()
        closeBtn = Btn(title: "", position: CGPoint(x: 40, y: size.height - 50))
        closeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        closeBtn.setTitle(String.fontAwesomeIcon(name: .close), for: .normal)

        super.init(nibName: nil, bundle: nil)
        self.view.frame = CGRect(x: 0, y: 0, width:size.width, height: size.height)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "padded")!)
        view.alpha = 0.97
        
        scrollView.frame = CGRect(x: 30, y: 30, width: size.width - 60, height: size.height - 90)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        closeBtn.addTarget(self, action: #selector(doneCall), for: .touchDown)
        view.addSubview(closeBtn)
        closeBtn.centerInParent()
        
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
    
    func hideClose() {
        closeBtn.removeFromSuperview()
    }
    
    func addSubview(v: UIView) {
        self.scrollView.addSubview(v)
        var contentRect = CGRect.zero
        for view in self.scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.scrollView.contentSize.height = contentRect.height
    }
    
    @objc func close() {
        DispatchQueue.main.async {
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}
