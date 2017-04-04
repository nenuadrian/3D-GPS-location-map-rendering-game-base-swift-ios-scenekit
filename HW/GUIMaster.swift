//
//  GUIMaster.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class GUIMaster {
    static var view: UIView!
    
    init(view: UIView) {
        GUIMaster.view = view
        refreshTasks()
        
        let invButton = UIButton(frame: CGRect(x: 10, y: 600, width: 70, height:30))
        invButton.setTitle("inv", for: .normal)
        invButton.addTarget(self, action: #selector(inventory), for: .touchUpInside)
        view.addSubview(invButton)
        
        let craftButton = UIButton(frame: CGRect(x: 90, y: 600, width: 70, height:30))
        craftButton.setTitle("craft", for: .normal)
        craftButton.addTarget(self, action: #selector(craft), for: .touchUpInside)
        view.addSubview(craftButton)
    }
    
    @objc func inventory() {
        GUIMaster.view.addSubview(InventoryView(frame: CGRect(x: 10, y: 10, width: 200, height: 500)))
    }
    
    @objc func craft() {
        GUIMaster.view.addSubview(CraftView(frame: CGRect(x: 10, y: 10, width: 200, height: 500)))
    }
    
    func refreshTasks() {
        // TODO go through children and find the ones which are task views and manage them
    }
    
    static func formula(formula: CraftFormula) {
        view.addSubview(FormulaView(frame: CGRect(x: 10, y: 10, width: 200, height: 500), formula: formula))
    }
    
    static func drop(data: JSON) {
        DispatchQueue.main.async {
            view.addSubview(DropView(frame: CGRect(x: 10, y: 10, width: 200, height: 500), items: data))
        }
    }
}

