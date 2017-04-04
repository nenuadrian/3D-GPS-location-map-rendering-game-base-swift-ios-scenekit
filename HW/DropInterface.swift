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

class DropItemView: UIView, UIGestureRecognizerDelegate {
    var item: Item!
    var selected: Bool = false

    init(frame: CGRect, item: Item) {
        self.item = item
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        nameLabel.text = "Item \(item.type)"
        addSubview(nameLabel)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        selected = !selected
        backgroundColor = selected ? UIColor.red : UIColor.clear
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropInterface: CardinalInterface {
    private var items: [DropItemView] = []
    
    func show(items: JSON) {

        var index = 0
        for item in items.array! {
            index += 1
            let itemView = DropItemView(frame: CGRect(x: 10, y: 40 * index, width: 100, height: 30), item: Item(data: item))
            self.items.append(itemView)
            addSubview(itemView)
        }
        
        let done = UIButton(frame: CGRect(x: 10, y: 200, width: 100, height:30))
        done.setTitle("done", for: .normal)
        done.addTarget(self, action: #selector(doneCall), for: .touchDown)

        addSubview(done)
    }
    
    func doneCall(_ sender: AnyObject?) {
        var params: [String : Any] = [:]
        params["items"] = items.filter({ $0.selected }).map({ $0.item.type })
        API.post(endpoint: "drop", params: params, callback: { (data) in
            self.items.filter({ $0.selected }).forEach({ Inventory.add(item: $0.item) })
        })
        
        close()
    }
    
}
