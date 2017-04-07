//
//  HomebaseInsideView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

class AppBitView2: UIView, UIGestureRecognizerDelegate {
    var app: App!
    
    init(frame: CGRect, app: App) {
        self.app = app
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        nameLabel.text = "App \(app.type) Cor: \(app.broken)"
        nameLabel.textColor = UIColor.white
        addSubview(nameLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        API.post(endpoint: "homebase/uninstall/\(app.id)") { (data) in
        }
        return false
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomebaseInterface: CardinalInterface {
    var apps: [App]!

    func show() {
        API.get(endpoint: "homebase") { (data) in
            self.apps = data["data"]["home_base"]["apps"].array!.map( { App(data: $0) } )
            DispatchQueue.main.async {
                self.show2()
            }
        }
    }
    
    func show2() {
        var index = 0
        for app in apps {
            index += 1
            let app = AppBitView2(frame: CGRect(x: 10, y: 40 * index, width: 100, height: 30), app: app)
            addSubview(v: app)
        }
 
        let install = UIButton(frame: CGRect(x: 200, y: 200, width: 100, height:30))
        install.setTitle("install", for: .normal)
        install.addTarget(self, action: #selector(self.installCall), for: .touchDown)
        addSubview(v: install)
    }
    
    @objc func installCall(_ sender: AnyObject?) {
        Cardinal.homebaseInstallApp()
        close()
    }

}
