//
//  Player.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Player: UIView {
    static var level: Int = 1
    static var exp: Int = 0
    static var group: Int = 0
    static var username: String = ""
    
    var tileKey: Vector2 = Vector2.zero
    var gridPointPosition: Vector2!
    var state: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func initPlayer(data: JSON) {
        Player.level = data["level"].int!
        Player.exp = data["exp"].int!
        Player.group = data["group"].int!
        Player.username = data["username"].string!
    }
    
    func someAction(_ sender:UITapGestureRecognizer) {
        API.put(endpoint: "tasks/homebase", callback: { (data) in
            if data["code"].int! == 200 {
            }
        })
    }
    
}
