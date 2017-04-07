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

class NPCBattle: CardinalInterface {
    private var socket: WebSocket!
    private var npc: NPC!
    
    func show(npc: NPC) {
        self.npc = npc
        let attack = Btn(title: "Attack", position: CGPoint(x: 50, y: 300))
        attack.addTarget(self, action: #selector(self.doAttack), for: .touchDown)
        addSubview(v: attack)
        attack.centerInParent()
        connect()
    }
    
    @objc func doAttack(_ sender: AnyObject?) {
        //let apps = [ Apps.apps()[0].id ]
        
        self.socket.write(string: JSON([ "action" : "attack" ]).rawString()!)
    }
    
    func connect() {
        socket = WebSocket(url: URL(string: Constants.BATTLE_SOCKET)!)
        socket.headers["token"] = API.getToken()
        

        socket.onConnect = {
            print("websocket is connected")
            self.socket.write(string: JSON([ "action" : "join_battle", "npc_id" : self.npc.id ]).rawString()!)

        }

        socket.onDisconnect = { (error: NSError?) in
            print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        }

        socket.onText = { (text: String) in
            let msg = JSON.parse(text)
            print(msg)

            if let action = msg["action"].string {
                if action == "defeated" {
                    DispatchQueue.main.async {
                        self.close()
                    }
                }
            }
        }

        socket.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }

        socket.connect()
        
    }
    
    deinit {
        socket.disconnect()
    }
}
