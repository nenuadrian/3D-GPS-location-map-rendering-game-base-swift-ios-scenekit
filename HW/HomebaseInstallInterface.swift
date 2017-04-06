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

class InstallAppBitView: UIView, UIGestureRecognizerDelegate {
    var app: App!
    
    init(frame: CGRect, app: App) {
        self.app = app
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        nameLabel.text = "App \(app.type)"
        nameLabel.textColor = UIColor.white
        addSubview(nameLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        API.post(endpoint: "homebase/install/\(app.id)") { (data) in
            Apps.apps.remove(at: Apps.apps.index(where: { $0.id == self.app.id })!)
            self.removeFromSuperview()

        }
        return false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomebaseInstallInterface: CardinalInterface {
    
    func show() {
        var index = 0
        for app in Apps.apps {
            index += 1
            let appBtiView = InstallAppBitView(frame: CGRect(x: 10, y: 40 * index, width: 100, height: 30), app: app)
            addSubview(v: appBtiView)
        }

    }
}
