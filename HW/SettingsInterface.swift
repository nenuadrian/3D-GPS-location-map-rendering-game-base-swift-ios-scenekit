//
//  NPCView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import SocketIO

class SettingsInterface: CardinalInterface {
    
    func show() {
        let logout = UIButton(frame: CGRect(x: frame.width/2-40, y: 300, width: 80, height: 30))
        logout.setTitle("logout", for: .normal)
        logout.addTarget(self, action: #selector(doLogout), for: .touchDown)
        addSubview(logout)
    }
    
    func doLogout(_ sender: AnyObject?) {
        Cardinal.logout()
    }
}
