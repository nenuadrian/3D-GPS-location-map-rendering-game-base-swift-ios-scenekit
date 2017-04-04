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
        
        let invButton = UIButton(frame: CGRect(x: 10, y: 600, width: 70, height:30))
        invButton.setTitle("inv", for: .normal)
        invButton.addTarget(self, action: #selector(inventory), for: .touchDown)
        view.addSubview(invButton)
        
        let craftButton = UIButton(frame: CGRect(x: 90, y: 600, width: 70, height:30))
        craftButton.setTitle("craft", for: .normal)
        craftButton.addTarget(self, action: #selector(craft), for: .touchDown)
        view.addSubview(craftButton)

    
        let appsButton = UIButton(frame: CGRect(x: 170, y: 600, width: 70, height:30))
        appsButton.setTitle("apps", for: .normal)
        appsButton.addTarget(self, action: #selector(apps), for: .touchDown)
        view.addSubview(appsButton)
    }
    
    @objc func inventory() {
        InventoryInterface().show()
    }
    
    @objc func apps() {
        AppsInterface().show()
    }
    
    @objc func craft() {
       CraftInterface().show()
    }
    
    static func homebase() {
        HomebaseInterface().show()
    }
    
    static func homebaseInstallApp() {
        HomebaseInstallInterface().show()
    }
    
    static func npc(npc: NPC) {
        NPCInterface().show(npc: npc)
    }
    
    static func formula(formula: CraftFormula) {
        FormulaInterface().show(formula: formula)
    }
    
    static func drop(data: JSON) {
        DispatchQueue.main.async {
            DropInterface().show(items: data)
        }
    }
}

