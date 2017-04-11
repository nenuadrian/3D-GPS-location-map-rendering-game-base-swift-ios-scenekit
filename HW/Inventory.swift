//
//  Inventory.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Item {
    var type: Int
    var q: Int
    
    init(type: Int, q: Int = 1) {
        self.type = type
        self.q = q
    }
    
    convenience init(data: JSON) {
        self.init(type: data["type"].int!, q: data["q"] != JSON.null ? data["q"].int! : 1)
    }
    
}

class Inventory {
    var items: [Item] = []
    
    func add(item: Item) {
        if let i = items.first(where: { $0.type == item.type }) {
            i.q += item.q
        } else {
            items.append(item)
        }
    }
    
    func remove(item: Item) {
        if let i = items.first(where: { $0.type == item.type }) {
            i.q -= item.q
            if let index = items.index(where: { $0.q == 0 }) {
                items.remove(at: index)
            }
        }
    }
    
    func initInventory(items: JSON) {
        for item in items.array! {
            add(item: Item(data: item))
        }
    }
    
    func has(item: Item) -> Bool {
        if let i = items.first(where: { $0.type == item.type }) {
            return i.q >= item.q
        }
        return false
    }
}
