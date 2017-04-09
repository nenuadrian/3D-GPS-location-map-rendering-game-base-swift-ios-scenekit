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

class HomebaseInstallInterface: CardinalInterface {
    
    func show() {
        var index = -1
        for app in Apps.apps() {
            index += 1
            let appBtiView = AppBitView(position: CGPoint(x: 0, y: (AppBitView.height + 10) * index), app: app, onTapTarget: self, onTap: #selector(onAppTap))
            addSubview(v: appBtiView)
        }

    }
    
    @objc func onAppTap(obj: Any, appBitView: AppBitView) {
        let app = obj as! App
        API.post(endpoint: "homebase/install/\(app.id)") { (data) in
            self.close()
        }
    }
}
