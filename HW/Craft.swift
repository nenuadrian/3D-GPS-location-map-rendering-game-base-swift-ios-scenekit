//
//  Craft.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation

class CraftFormula {
    var id: Int!
    var item: Item!
    var app: App!
    var items: [Item] = []
    init (id: Int, item: Item, items: [Item]) {
        self.id = id
        self.item = item
        self.items = items
    }
    
    init (id: Int, app: App, items: [Item]) {
        self.id = id
        self.app = app
        self.items = items
    }
    
    func canCraft() -> Bool {
        for item in items {
            if !Cardinal.player.inventory.has(item: item) {
                return false
            }
        }
        return true
    }
}

class Craft {
    static var formulas: [CraftFormula] = [
        CraftFormula(id: 1, item: Item(type: 2), items: [Item(type: 1, q: 3)]),
        CraftFormula(id: 2, app: App(type: 1), items: [Item(type: 2, q: 1)])
    ]
}
