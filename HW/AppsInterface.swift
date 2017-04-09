//
//  DropView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//


import Foundation
import UIKit
import SwiftyJSON

class AppBitView: UIView, UIGestureRecognizerDelegate {
    let app: App
    private let onTap: Selector?
    private let onTapTarget: NSObject?
    private var selected: Bool = false
    static let height: Int = 80

    init(position: CGPoint, app: App, onTapTarget: NSObject? = nil, onTap: Selector? = nil) {
        self.app = app
        self.onTap = onTap
        self.onTapTarget = onTapTarget
        super.init(frame: CGRect(x: position.x, y: position.y, width: CardinalInterface.subviewWidth, height: CGFloat(AppBitView.height)))
        
        let nameLabel = Label(text: "App \(Constants.APPS[app.type]!.name)", frame: CGRect(x: 15, y: 15, width: 250, height: 20))
        addSubview(nameLabel)
        
        if app.broken > 0 {
            let corLabel = Label(text: "corrupted \(app.broken)", frame: CGRect(x: self.frame.width - 220, y: self.frame.height - 30, width: 200, height: 20))
            corLabel.textAlignment = .right
            addSubview(corLabel)
        }
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red:0.00, green:0.49, blue:0.86, alpha: 0.5).cgColor
        
        if self.onTap != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: nil)
            tapGesture.delegate = self
            addGestureRecognizer(tapGesture)
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let onTap = self.onTap {
           let _ = onTapTarget?.perform(onTap, with: app, with: self)
        }
        return false
    }
    
    func isSelected() -> Bool { return selected }
    
    func selectToggle() { setSelect(to: !selected) }
    
    func setSelect(to: Bool) {
        selected = to
        if selected {
            backgroundColor = UIColor.white.withAlphaComponent(0.1)
        } else {
            backgroundColor =  UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppsInterface: CardinalInterface {
    
    func show() {
        let craftButton = Btn(title: "craft", position: CGPoint(x: 0, y: 0))
        craftButton.addTarget(self, action: #selector(openCraft), for: .touchDown)
        addSubview(v: craftButton)
        
        let invButton = Btn(title: "inv", position: CGPoint(x: 0, y: 0))
        invButton.addTarget(self, action: #selector(openItems), for: .touchDown)
        addSubview(v: invButton)
        invButton.rightInParent()
        
        for app in Apps.apps() {
            let appBtiView = AppBitView(position: CGPoint(x: 0, y: 60 + (AppBitView.height + 10) * Apps.apps().index(where: { $0.id == app.id })!), app: app)
            addSubview(v: appBtiView)
        }
    }
    
    @objc func openCraft(_ sender: AnyObject?) {
        CraftInterface().show()
    }
    
    @objc func openItems(_ sender: AnyObject?) {
        InventoryInterface().show()
    }
}
