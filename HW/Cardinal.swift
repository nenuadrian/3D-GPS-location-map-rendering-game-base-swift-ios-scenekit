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
        let appsButton = Btn(title: "apps", position: CGPoint(x: 170, y: 620))
        appsButton.addTarget(self, action: #selector(apps), for: .touchDown)
        view.addSubview(appsButton)
                
        if Constants.DEBUG {
            let debug = Btn(title: "D", position: CGPoint(x: 20, y: 20))
            debug.addTarget(self, action: #selector(debugCall), for: .touchDown)
            view.addSubview(debug)
        }
    }
    
    @objc func debugCall() {
        DebugInterface().show()
    }
    
    @objc func apps() {
        AppsInterface().show()
    }
    
    static func drop(data: JSON) {
        DispatchQueue.main.async {
            DropInterface().show(items: data)
        }
    }
    
    static func logout() {
        let cardinal = Cardinal.myInstance!
        cardinal.world.shutdown()
        API.deleteToken()
        Cardinal.player = nil
        Cardinal.myInstance = nil
        NotificationCenter.default.removeObserver(self)
        cardinal.removeFromParentViewController()
        cardinal.present(AuthViewController(), animated: false, completion: nil)
        cardinal.view.removeFromSuperview()
    }
    
    deinit {
        Logging.info(data: "Deiniting Cardinal")
    }
    
}

