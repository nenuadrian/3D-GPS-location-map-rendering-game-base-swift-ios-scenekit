//
//  Constants.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation

class ItemInfo {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class AppInfo {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Constants {
    static let REST_HOST = "http://127.0.0.1:3001/"
    static let BATTLE_SOCKET = "ws://localhost:3005/"
    static let TILE_RANGE = 2
    static let DEBUG = true
    static let ITEMS = [
        1: ItemInfo(name: "General A.I. core piece"),
        2: ItemInfo(name: "Security Knowledge Circuit"),
        ]
    static let APPS = [
        1: AppInfo(name: "Security A.I."),
        2: AppInfo(name: "Firewall v1"),
        ]
}
