//
//  FormulaView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

class FormulaView: UIView {
    var formula: CraftFormula!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, formula: CraftFormula) {
        self.formula = formula
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 300, height: 20))
        nameLabel.text = "Craft \(formula.item) \(formula.app)"
        addSubview(nameLabel)
        
        backgroundColor = UIColor.yellow
        
        let craft = UIButton(frame: CGRect(x: 10, y: 200, width: 100, height:30))
        craft.setTitle("craft", for: .normal)
        craft.addTarget(self, action: #selector(craftCall), for: .touchUpInside)
        addSubview(craft)
    }
    
    func craftCall(_ sender: AnyObject?) {
        if formula.canCraft() {
            formula.items.forEach({ Inventory.remove(item: $0 )})
            API.post(endpoint: "tasks/craft/\(formula.id!)", callback: { (data) in
                
            })
            removeFromSuperview()
        } else {
            print("Cannot craft")
        }
    }

    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
