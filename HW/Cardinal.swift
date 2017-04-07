//
//  Cardinal.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import QRCode



class Cardinal: UIViewController {
    static var player: Player!
    private var world: World3D
    static var myInstance: Cardinal!
     
    init(data: JSON) {
        world = World3D()
        super.init(nibName: nil, bundle: nil)
        Cardinal.myInstance = self

        Cardinal.player = Player(data: data["player"])
        Cardinal.player.initGridPoints(data: data["grid_points"])
        TasksManager.initTasks(tasks: data["tasks"])
        Inventory.initInventory(items: data["player"]["inventory"])
        Apps.initApps(apps: data["player"]["apps"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        addChildViewController(world)
        world.view.frame = self.view.frame
        view.addSubview(world.view)
        world.didMove(toParentViewController: self)
        setupGUI()
    }
    
    private func setupGUI() {
        let invButton = UIButton(frame: CGRect(x: 10, y: 620, width: 70, height:30))
        invButton.setTitle("inv", for: .normal)
        invButton.addTarget(self, action: #selector(inventory), for: .touchDown)
        view.addSubview(invButton)
        
        let craftButton = UIButton(frame: CGRect(x: 90, y: 620, width: 70, height:30))
        craftButton.setTitle("craft", for: .normal)
        craftButton.addTarget(self, action: #selector(craft), for: .touchDown)
        view.addSubview(craftButton)
        
        let appsButton = UIButton(frame: CGRect(x: 170, y: 620, width: 70, height:30))
        appsButton.setTitle("apps", for: .normal)
        appsButton.addTarget(self, action: #selector(apps), for: .touchDown)
        view.addSubview(appsButton)
        
        let qrButton = UIButton(frame: CGRect(x: 230, y: 620, width: 70, height:30))
        qrButton.setTitle("qr", for: .normal)
        qrButton.addTarget(self, action: #selector(qr), for: .touchDown)
        view.addSubview(qrButton)
      
        //QRCodeInterface().show(data: "qrCode")

        let settings = UIButton(frame: CGRect(x: 280, y: 620, width: 70, height:30))
        settings.setTitle("set", for: .normal)
        settings.addTarget(self, action: #selector(settingsCall), for: .touchDown)
        view.addSubview(settings)

        
        let aug = UIButton(frame: CGRect(x: 280, y: 540, width: 70, height:30))
        aug.setTitle("aug", for: .normal)
        aug.addTarget(self, action: #selector(augumentedCall), for: .touchDown)
        view.addSubview(aug)
        
        if Constants.DEBUG {
            let debug = Btn(title: "debug", position: CGPoint(x: 260, y: 500))
            debug.addTarget(self, action: #selector(debugCall), for: .touchDown)
            view.addSubview(debug)
        }
    }
    
   
    @objc func augumentedCall() {
        let augumented = AugmentedViewController()
        addChildViewController(augumented)
        augumented.view.frame = self.view.frame
        view.addSubview(augumented.view)
        augumented.didMove(toParentViewController: self)
    }
    
    @objc func settingsCall() {
        SettingsInterface().show()
    }
    
    @objc func debugCall() {
        DebugInterface().show()
    }
    
    @objc func qr() {
        let reader = QRReadViewController()
        addChildViewController(reader)
        reader.view.frame = self.view.frame
        view.addSubview(reader.view)
        reader.didMove(toParentViewController: self)
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
    
    static func logout() {
        let cardinal = Cardinal.myInstance!
        Cardinal.myInstance = nil

        Cardinal.player = nil
        API.deleteToken()
        NotificationCenter.default.removeObserver(cardinal)
        cardinal.world.shutdown()
        cardinal.removeFromParentViewController()
        cardinal.present(AuthViewController(), animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

