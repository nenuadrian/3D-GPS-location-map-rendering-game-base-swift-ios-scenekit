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
import Starscream

class BattleInfo {
    var health: Int
    
    init(health: Int) {
        self.health = health
    }
    
    convenience init (data: JSON) {
        self.init(health: data["health"].int!)
    }
}

class NPCBattle: CardinalInterface {
    private var socket: WebSocket!
    private var npc: NPC!
    private var battleInfo: BattleInfo!
    private var healthLabel: UILabel!
    private var progress: UILabel!
    private var apps: [App]!
    
    func show(npc: NPC) {
        hideClose()
        self.npc = npc
        AppPickingInterface().show(onPickTarget: self, onPick: #selector(appsPicked))
        
        
        self.progress = Label(text: "", frame: CGRect(x: 100, y: 350, width: CardinalInterface.subviewWidth, height: 500))
        self.progress.numberOfLines = 100
        self.progress.textAlignment = .center
        self.addSubview(v: self.progress)
        self.progress.centerInParent()
    }
    
    @objc func doAttack(_ sender: AnyObject?) {
        self.socket.write(string: JSON([ "action" : "attack" ]).rawString()!)
    }
    
    func connect() {
        socket = WebSocket(url: URL(string: Constants.BATTLE_SOCKET)!)
        socket.headers["token"] = API.getToken()
        

        socket.onConnect = {
            print("websocket is connected")
        }

        socket.onDisconnect = { (error: NSError?) in
            print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        }

        socket.onText = { (text: String) in
            let msg = JSON.parse(text)
            Logging.info(data: msg.rawString()!)
            if let action = msg["action"].string {
                if action == "ready" {
                    self.socket.write(string: JSON([ "action" : "join_battle", "npc_id" : self.npc.id, "apps": self.apps.map { $0.id } ]).rawString()!)
                }
                
                if action == "defeated" {
                    DispatchQueue.main.async {
                        self.npc.update(data: JSON([]))
                        self.close()
                    }
                }
                
                if action == "joined_battle" {
                    DispatchQueue.main.async {
                        self.progress.text = "\(msg["user"]["id"].string!) joined \n\(self.progress.text!)"
                    }
                }
                
                if action == "left_battle" {
                    DispatchQueue.main.async {
                        self.progress.text = "\(msg["user"].string!) left \n\(self.progress.text!)"
                    }
                }
                
                if action == "battle" {
                    self.battleInfo = BattleInfo(data: msg["data"])
                    self.beginBattle()
                }
                
                if action == "damage" {
                    self.battleInfo.health = self.battleInfo.health - msg["value"].int!
                    self.updateBattle()
                    
                    DispatchQueue.main.async {
                        self.progress.text = "\(msg["user"].string!) dmg \(msg["value"].int!)\n\(self.progress.text!)"
                    }
                }
                
                if action == "404" {
                    self.close()
                }
            }
        }

        socket.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }

        socket.connect()
        
    }
    
    func updateBattle() {
        DispatchQueue.main.async {
            self.healthLabel.text = "\(self.battleInfo.health) health"
        }
    }
    
    func beginBattle() {
        DispatchQueue.main.async {
            let attack = Btn(title: "Attack", position: CGPoint(x: 50, y: 300))
            attack.addTarget(self, action: #selector(self.doAttack), for: .touchDown)
            self.addSubview(v: attack)
            attack.centerInParent()

            self.healthLabel = Label(text:"0", frame: CGRect(x: 100, y: 200, width: 300, height: 30))
            self.addSubview(v: self.healthLabel)

            

            self.updateBattle()
        }
    }
    
    func appsPicked(apps: [String]) {
        self.apps = Cardinal.player.apps.apps().filter { apps.contains($0.id) }
        connect()
    }
    
    deinit {
        socket.disconnect()
    }
}
