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

class NPCInterface: CardinalInterface {
    private var socket: WebSocket!
    
    func show(npc: NPC) {
        
        if npc.type == 2 {
            socket = WebSocket(url: URL(string: "ws://localhost:3005/")!)
            socket.headers["Sec-WebSocket-Protocol"] = "someother protocols"

            //websocketDidConnect
            socket.onConnect = {
                print("websocket is connected")
                self.socket.write(string: "Hi Server!")
            }
            //websocketDidDisconnect
            socket.onDisconnect = { (error: NSError?) in
                print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
            }
            //websocketDidReceiveMessage
            socket.onText = { (text: String) in
                print("got some text: \(text)")
            }
            //websocketDidReceiveData
            socket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            //you could do onPong as well.
            socket.connect()
            
        }
    }
    
}
