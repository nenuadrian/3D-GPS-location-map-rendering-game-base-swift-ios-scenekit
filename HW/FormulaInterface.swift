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
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 300, height: 20))
        nameLabel.text = "Craft \(formula.item) \(formula.app)"
        
        let craft = UIButton(frame: CGRect(x: 10, y: 200, width: 100, height:30))
        craft.setTitle("craft", for: .normal)
        craft.addTarget(self, action: #selector(craftCall), for: .touchDown)
        
        addSubview(v: nameLabel)
        addSubview(v: craft)
    }
    
    @objc func craftCall(_ sender: AnyObject?) {
        if formula.canCraft() {
            formula.items.forEach({ Inventory.remove(item: $0 )})
            API.post(endpoint: "tasks/craft/\(formula.id!)", callback: { (data) in
                
            })
            close()
        } else {
            print("Cannot craft")
        }
    }
}
