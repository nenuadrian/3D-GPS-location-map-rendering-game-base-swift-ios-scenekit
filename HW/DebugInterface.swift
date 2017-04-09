

import Foundation
import UIKit
import SwiftyJSON
class DebugInterface: CardinalInterface {
    let lat = FormUITextField(frame: CGRect(x: 20, y: 20, width:100, height:30))
    let lon = FormUITextField(frame: CGRect(x: 20, y: 70, width:100, height:30))
    
    func show() {
        lat.text = "\(LocationMaster.debugLast.x)"
        lon.text = "\(LocationMaster.debugLast.y)"
        addSubview(v: lat)
        addSubview(v: lon)
        
        let move = Btn(title: "Move", position: CGPoint(x: 20, y: 110))
        move.addTarget(self, action: #selector(moveCall), for: .touchDown)
        addSubview(v: move)
    }
    
    @objc func moveCall() {
        LocationMaster.debugLast = Vector2(Float(lat.text!)!, Float(lon.text!)!)
    }
    
}
