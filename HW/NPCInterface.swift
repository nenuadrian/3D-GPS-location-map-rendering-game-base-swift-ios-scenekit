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
    private var npc: NPC!
    
    func show(npc: NPC) {
        self.npc = npc
        let occupy = Btn(title: "Occupy", position: CGPoint(x: 50, y: 300))
        occupy.addTarget(self, action: #selector(self.doOccupy), for: .touchDown)
        
        let attack = Btn(title: "Attack", position: CGPoint(x: 50, y: 300))
        attack.addTarget(self, action: #selector(self.doAttack), for: .touchDown)
        
        API.get(endpoint: "npc/\(npc.id)") { (data) in
            npc.update(data: data["data"]["npc"])
            if npc.type == 2 {
                DispatchQueue.main.async {
                    if npc.occupy == nil {
                        attack.removeFromSuperview()
                        self.addSubview(v: occupy)
                    } else {
                        self.addSubview(v: attack)
                        occupy.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @objc func doOccupy(_ sender: AnyObject?) {
        let apps = [ Apps.apps()[0].id ]
        API.post(endpoint: "npc/\(npc.id)/occupy", params: [ "apps": apps ]) { (data) in
        }
    }
    
    @objc func doAttack(_ sender: AnyObject?) {
        NPCBattle().show(npc: npc)
        close()
    }

    
}
