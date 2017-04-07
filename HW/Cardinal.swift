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


class TaskView: UIView {
    let task: Task
    init(task: Task) {
        self.task = task
        super.init(frame: CGRect(x: Int(UIScreen.main.bounds.width - 50), y: 50 * (Cardinal.taskViews.count + 1), width: 30, height: 30))
        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Cardinal: UIViewController {
    private let player: Player! = nil
    private var world: World3D!
    static var taskViews: [TaskView] = []
    static var myInstance: Cardinal!
    let lat = UITextField(frame: CGRect(x: 260, y:400, width:100, height:30))
    let lon = UITextField(frame: CGRect(x: 260, y:450, width:100, height:30))
    
    override func viewDidLoad() {
        Cardinal.myInstance = self
        world = World3D()
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

        TasksManager.tasks.forEach({ Cardinal.addTask(task: $0.value) })
        
        
        if Constants.DEBUG {
            lat.text = "\(LocationMaster.debugLast.x)"
            
            lon.text = "\(LocationMaster.debugLast.y)"
            view.addSubview(lat)
            view.addSubview(lon)
            
            let move = UIButton(frame: CGRect(x: 260, y: 500, width: 70, height:30))
            move.setTitle("move", for: .normal)
            move.addTarget(self, action: #selector(moveCall), for: .touchDown)
            view.addSubview(move)
        }
    }
    
    @objc func moveCall() {
        LocationMaster.debugLast = Vector2(Float(lat.text!)!, Float(lon.text!)!)
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
    
    static func addTask(task: Task) {
         DispatchQueue.main.async {
            taskViews.append(TaskView(task : task))
            myInstance.view.addSubview(taskViews.last!)
        }
    }
    
    static func removeTask(task: Task) {
        if let t = taskViews.first(where: { $0.task.id == task.id }) {
             DispatchQueue.main.async {
                t.removeFromSuperview()
                taskViews.remove(at: taskViews.index(where: { $0 == t })!)
            }

        }
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
        API.deleteToken()
        Cardinal.myInstance.world.shutdown()
        Cardinal.myInstance.present(AuthViewController(), animated: true, completion: nil)
        Player.current = nil
        Cardinal.myInstance.removeFromParentViewController()
        Cardinal.myInstance = nil
    }
}

