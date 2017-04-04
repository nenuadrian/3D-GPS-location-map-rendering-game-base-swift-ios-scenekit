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

class ItemView: UIView, UIGestureRecognizerDelegate {
    var item: Item!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, item: Item) {
        self.item = item
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        nameLabel.text = "Item \(item.type) x \(item.q)"
        addSubview(nameLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InventoryInterface: CardinalInterface {
    
    func show() {
        
        var index = 0
        for item in Inventory.items {
            index += 1
            let itemView = ItemView(frame: CGRect(x: 10, y: 40 * index, width: 100, height: 30), item: item)
            addSubview(itemView)
        }
        
        let done = UIButton(frame: CGRect(x: 10, y: 200, width: 100, height:30))
        done.setTitle("done", for: .normal)
        done.addTarget(self, action: #selector(doneCall), for: .touchDown)
        
        addSubview(done)
    }
    
    func doneCall(_ sender: AnyObject?) {
        close()
    }
    
}
