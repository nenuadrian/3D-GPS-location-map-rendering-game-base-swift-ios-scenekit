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
    static let height = 100
    private let onTap: Selector?
    private let onTapTarget: NSObject?
    
    init(position: CGPoint, formula: CraftFormula, onTapTarget: NSObject?, onTap: Selector?) {
        self.onTap = onTap
        self.onTapTarget = onTapTarget
        self.formula = formula
        super.init(frame: CGRect(x: position.x, y: position.y, width: CardinalInterface.subviewWidth, height: CGFloat(FormulaBitView.height)))
        
        if formula.item != nil {
            let itemView = ItemBitView(position: CGPoint(x: 0, y: 0), item: formula.item)
            addSubview(itemView)
        } else {
            let appView = AppBitView(position: CGPoint(x: 0, y: 0), app: formula.app)
            addSubview(appView)
        }
        
        if self.onTap != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: nil)
            tapGesture.delegate = self
            addGestureRecognizer(tapGesture)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let onTap = self.onTap {
            let _ = onTapTarget?.perform(onTap, with: formula, with: self)
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CraftInterface: CardinalInterface {
    
    func show() {
        var index = -1
        for formula in Craft.formulas {
            index += 1
            let formulaView = FormulaBitView(position: CGPoint(x: 0, y: (FormulaBitView.height + 10) * index), formula: formula, onTapTarget: self, onTap: #selector(onFormulaTap))
            addSubview(v: formulaView)
        }
    }
    
    @objc func onFormulaTap(obj: Any, formula: FormulaBitView) {
        let formula = obj as! CraftFormula
        FormulaInterface().show(formula: formula)
        self.close()
    }
}
