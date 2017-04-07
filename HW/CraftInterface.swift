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
        
        let formulaBtn = Btn(title: "Craft \(formula.item) \(formula.app)", position: CGPoint(x: 0, y: 0))
        formulaBtn.titleLabel?.textAlignment = .left
        addSubview(formulaBtn)
        formulaBtn.addTarget(self, action: #selector(doFormula), for: .touchDown)
    }
    
    func doFormula(_ sender: AnyObject?) {
        Cardinal.formula(formula: formula)
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
            let formulaView = FormulaBitView(frame: CGRect(x: 10, y: 40 * index, width: 200, height: 30), formula: formula)
            addSubview(v: formulaView)
        }
    }
}
