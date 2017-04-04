//
//  AuthViewController.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        API.setToken(token: "$2a$10$z4sy3eTeGRIGliMO1uRoI.fiw8fV7VX.dsgycG8jshV7USGv0FPYu")
        
        API.get(endpoint: "player", callback: { data in
            Player.initPlayer(data: data["data"]["player"])
            TasksManager.initTasks(tasks: data["data"]["tasks"])
            Inventory.initInventory(items: data["data"]["player"]["inventory"])
            Apps.initApps(apps: data["data"]["player"]["apps"])
            DispatchQueue.main.async {
                let secondViewController: WorldViewController = WorldViewController()
                self.present(secondViewController, animated: true, completion: nil)
            }
            
        })
    }
}
