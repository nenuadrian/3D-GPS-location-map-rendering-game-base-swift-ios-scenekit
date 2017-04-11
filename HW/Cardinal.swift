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
        Cardinal.player.taskManager.initTasks(tasks: data["tasks"])
        Cardinal.player.inventory.initInventory(items: data["player"]["inventory"])
        Cardinal.player.apps.initApps(apps: data["player"]["apps"])
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
        let appsButton = Btn(title: "apps", position: CGPoint(x: 170, y: 600))
        appsButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        appsButton.setTitle(String.fontAwesomeIcon(name: .bolt), for: .normal)
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
    
    static func logout() {
        let cardinal = Cardinal.myInstance!
        Cardinal.myInstance = nil
        cardinal.world.shutdown()
        API.deleteToken()
        cardinal.navigationController?.pushViewController(AuthViewController(), animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.viewControllers = [(self.navigationController?.viewControllers.last)!]
    }
    
    deinit {
        Cardinal.player = nil
        NotificationCenter.default.removeObserver(self)
        Logging.info(data: "Deiniting Cardinal")
    }
    
}

