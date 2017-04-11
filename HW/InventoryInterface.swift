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

class ItemBitView: UIView, UIGestureRecognizerDelegate {
    let item: Item
    private let onTap: Selector?
    private let onTapTarget: NSObject?
    private var selected: Bool = false
    static let height = 80
    
    init(position: CGPoint, item: Item, onTapTarget: NSObject? = nil, onTap: Selector? = nil) {
        self.item = item
        self.onTap = onTap
        self.onTapTarget = onTapTarget
        super.init(frame: CGRect(x: position.x, y: position.y, width: CardinalInterface.subviewWidth, height: CGFloat(ItemBitView.height)))
        
        let nameLabel = Label(text: Constants.ITEMS[item.type]!.name, frame: CGRect(x: 15, y: 15, width: 300, height: 20))
        addSubview(nameLabel)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red:0.00, green:0.49, blue:0.86, alpha: 0.5).cgColor
        
        if item.q > 1 {
            let qLabel = Label(text: "\(item.q) pieces", frame: CGRect(x: frame.width - 160, y: frame.height - 30, width: 150, height: 20))
            qLabel.textAlignment = .right
            addSubview(qLabel)
        }
        
        if onTap != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: nil)
            tapGesture.delegate = self
            addGestureRecognizer(tapGesture)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let onTap = self.onTap {
            let _ = onTapTarget?.perform(onTap, with: item, with: self)
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
            backgroundColor = UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InventoryInterface: CardinalInterface {
    
    func show() {
        let craftButton = Btn(title: "craft", position: CGPoint(x: 0, y: 0))
        craftButton.addTarget(self, action: #selector(openCraft), for: .touchDown)
        addSubview(v: craftButton)
        craftButton.centerInParent()

    
        for item in Cardinal.player.inventory.items {
            let itemView = ItemBitView(position: CGPoint(x: 0, y: 60 + (ItemBitView.height + 10) * Cardinal.player.inventory.items.index(where: { $0.type == item.type })!), item: item)
            addSubview(v: itemView)
        }

    }

    @objc func openCraft(_ sender: AnyObject?) {
        CraftInterface().show()
    }

}
