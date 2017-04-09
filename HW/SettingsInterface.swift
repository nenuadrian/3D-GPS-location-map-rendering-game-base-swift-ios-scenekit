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
import FontAwesome

class SettingsInterface: CardinalInterface {
    
    func show() {
        let logout = Btn(title: "", position: CGPoint(x: 0, y: 500))
        logout.addTarget(self, action: #selector(doLogout), for: .touchDown)
        addSubview(v: logout)
        logout.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        logout.setTitle(String.fontAwesomeIcon(name: .powerOff), for: .normal)
        logout.centerInParent()
    }
    
    func doLogout(_ sender: AnyObject?) {
        Cardinal.logout()
    }
}
