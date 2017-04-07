//
//  QRCodeInterface.swift
//  HW
//
//  Created by Adrian Nenu on 05/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import QRCode

class QRCodeInterface: CardinalInterface {
    func show(data: String) {
        let qrCode = QRCode(data)
        let imageView = UIImageView(qrCode: qrCode!)
        addSubview(v: imageView)
    }
}
