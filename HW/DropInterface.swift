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


class DropInterface: CardinalInterface {
    
    func show(items: JSON) {
        hideClose()
        let parsedItems = items.array!.map({ Item(data: $0) })
        var index = -1
        for item in parsedItems {
            index += 1
            let itemView = ItemBitView(position: CGPoint(x: 0, y: (ItemBitView.height + 10) * index), item: item, onTapTarget: self, onTap: #selector(onItemTap))
            addSubview(v: itemView)
        }
        
        let done = Btn(title: "PICK UP", position: CGPoint(x: 10, y: UIScreen.main.bounds.height - 50))
        done.addTarget(self, action: #selector(pickCall), for: .touchDown)
        view.addSubview(done)
        done.centerInParent()

    }
    
    @objc func onItemTap(obj: Any, itemBitView: ItemBitView) {
        //let item = obj as! Item
        itemBitView.selectToggle()
    }
    
    func pickCall(_ sender: AnyObject?) {
        let params = [ "items" : scrollView.subviews.flatMap { $0 as? ItemBitView }.filter { $0.isSelected() }.map { $0.item }.map({ $0.type }) ]
        print(params)
        API.post(endpoint: "drop", params: params, callback: { (data) in
        })
        
        close()
    }
    
}
