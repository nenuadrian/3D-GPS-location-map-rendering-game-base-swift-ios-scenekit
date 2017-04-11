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

class PlayerInterface: CardinalInterface {
    
    func show() {
        
        let name = Btn(title: Cardinal.player.username, position: CGPoint(x: 0, y: 20))
        name.setFont(size: 25)
        addSubview(v: name)
        name.centerInParent()
        name.addTarget(self, action: #selector(doName), for: .touchDown)
        
        let level = Label(text: "L\(Cardinal.player.level)", frame: CGRect(x: 0, y: 50, width: CardinalInterface.subviewWidth, height: 30))
        level.textAlignment = .center
        addSubview(v: level)
        
        let homebase = Btn(title: "place homebase", position: CGPoint(x: 0, y: 140))
        homebase.addTarget(self, action: #selector(doHomebase), for: .touchDown)
        addSubview(v: homebase)
        homebase.centerInParent()
        
        let qrButton = Btn(title: "qr scan", position: CGPoint(x: 0, y: 200))
        qrButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        qrButton.setTitle(String.fontAwesomeIcon(name: .qrcode), for: .normal)
        qrButton.addTarget(self, action: #selector(qr), for: .touchDown)
        addSubview(v: qrButton)
        qrButton.centerInParent()
        
        let settings = Btn(title: "settings", position: CGPoint(x: 0, y: 240))
        settings.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        settings.setTitle(String.fontAwesomeIcon(name: .cog), for: .normal)
        settings.addTarget(self, action: #selector(settingsCall), for: .touchDown)
        addSubview(v: settings)
        settings.centerInParent()
    }
    
    @objc func doName(_ sender: AnyObject?) {
        QRCodeInterface().show(data: "qrCode")
    }
    
    @objc func doHomebase(_ sender: AnyObject?) {
        API.put(endpoint: "tasks/homebase", callback: { (data) in
            if data["code"].int! == 200 {
                self.close()
            }
        })
    }
    
    @objc func settingsCall() {
        SettingsInterface().show()
    }
    
    @objc func qr() {
        let reader = QRReadViewController()
        addChildViewController(reader)
        reader.view.frame = self.view.frame
        view.addSubview(reader.view)
        reader.didMove(toParentViewController: self)
    }
}

