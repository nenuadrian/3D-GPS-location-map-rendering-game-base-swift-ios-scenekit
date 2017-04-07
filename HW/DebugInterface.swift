

import Foundation
import UIKit
import SwiftyJSON
class DebugInterface: CardinalInterface {
    let lat = FormUITextField(frame: CGRect(x: 260, y:400, width:100, height:30))
    let lon = FormUITextField(frame: CGRect(x: 260, y:450, width:100, height:30))
    
    func show() {
        lat.text = "\(LocationMaster.debugLast.x)"
        lon.text = "\(LocationMaster.debugLast.y)"
        addSubview(v: lat)
        addSubview(v: lon)
        
        let move = Btn(title: "Move", position: CGPoint(x: 260, y: 500))
        move.addTarget(self, action: #selector(moveCall), for: .touchDown)
        addSubview(v: move)
    }
    
    
    @objc func moveCall() {
        LocationMaster.debugLast = Vector2(Float(lat.text!)!, Float(lon.text!)!)
    }
    
}
