//
//  NPCView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import SocketIO

class FormulaInterface: CardinalInterface {
    var formula: CraftFormula!
    
    func show(formula: CraftFormula) {
        self.formula = formula
        let nameLabel = Label(text: "FORMULA", frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        nameLabel.textAlignment = .center
        nameLabel.font = nameLabel.font.withSize(20)
        addSubview(v: nameLabel)
        
        if formula.item != nil {
            let itemLabel = ItemBitView(position: CGPoint(x: 0, y: 40), item: formula.item)
            addSubview(v: itemLabel)
        } else {
            let appLabel = AppBitView(position: CGPoint(x: 0, y: 40), app: formula.app)
            addSubview(v: appLabel)
        }
        
        var index = -1
        for item in formula.items {
            index += 1
            let itemLabel = ItemBitView(position: CGPoint(x: 0, y: 200 + ItemBitView.height * index), item: item)
            addSubview(v: itemLabel)
        }
        
        if formula.canCraft() {
            let craft = Btn(title: "craft", position: CGPoint(x: 0, y: 140))
            craft.addTarget(self, action: #selector(craftCall), for: .touchDown)
            addSubview(v: craft)
            craft.centerInParent()
        }
    }
    
    @objc func craftCall(_ sender: AnyObject?) {
        API.post(endpoint: "tasks/craft/\(formula.id!)", callback: { (data) in
            self.close()
        })
    }
}
