//
//  HomebaseInsideView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit

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
            let app = AppBitView(frame: CGRect(x: 10, y: 40 * index, width: 100, height: 30), app: app)
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
