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


class AppPickingInterface: CardinalInterface {
    var onPick: Selector!
    var onPickTarget: NSObject!

    func show(onPickTarget: NSObject, onPick: Selector) {
        hideClose()
        self.onPick = onPick
        self.onPickTarget = onPickTarget
        var index = 0
        for app in Cardinal.player.apps.apps() {
            index += 1
            let appBtiView = AppBitView(position: CGPoint(x: 0, y: (AppBitView.height + 10) * index), app: app, onTapTarget: self, onTap: #selector(onAppTap))
            addSubview(v: appBtiView)
        }
        
        let done = Btn(title: "USE APPS", position: CGPoint(x: 10, y: UIScreen.main.bounds.height - 50))
        done.addTarget(self, action: #selector(pickCall), for: .touchDown)
        view.addSubview(done)
        done.centerInParent()
    }
    
    @objc func onAppTap(obj: Any, appBitView: AppBitView) {
        appBitView.selectToggle()
    }
    
    func getSelected() -> [App] {
        return scrollView.subviews.flatMap { $0 as? AppBitView }.filter { $0.isSelected() } .map { $0.app }
    }
    
    func pickCall(_ sender: AnyObject?) {
        let apps = getSelected().map { $0.id }
        let _ = onPickTarget?.perform(onPick, with: apps)
        close()
    }
    
}
