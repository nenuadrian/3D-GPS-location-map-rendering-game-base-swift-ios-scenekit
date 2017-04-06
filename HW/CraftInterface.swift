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

class FormulaBitView: UIView, UIGestureRecognizerDelegate {
    var formula: CraftFormula!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, formula: CraftFormula) {
        self.formula = formula
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        nameLabel.text = "Craft \(formula.item) \(formula.app)"
        nameLabel.textColor = UIColor.white
        addSubview(nameLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        GUIMaster.formula(formula: formula)
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CraftInterface: CardinalInterface {
    
    func show() {
        var index = 0
        for formula in Craft.formulas {
            index += 1
            let formulaView = FormulaBitView(frame: CGRect(x: 10, y: 40 * index, width: 100, height: 30), formula: formula)
            addSubview(v: formulaView)
        }
    }
}
