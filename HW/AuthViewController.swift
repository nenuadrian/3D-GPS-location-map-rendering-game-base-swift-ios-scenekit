//
//  AuthViewController.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Btn: UIButton {
    init(title: String, position: CGPoint, type: String = "default") {
        super.init(frame: CGRect(x: position.x, y: position.y, width: CGFloat(title.characters.count * 7 + 20), height: 30))
        self.titleLabel?.font = UIFont (name: "Josefin Sans", size: 20)
        setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centerInParent() {
        self.frame = CGRect(x: self.superview!.frame.width / 2 - self.frame.width / 2, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
    }

}

class FormUITextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 13, right: 5);

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textColor = UIColor(red:0.00, green:0.49, blue:0.86, alpha:1.0)
        self.font = UIFont (name: "Josefin Sans", size: 18)
    

        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red:0.00, green:0.49, blue:0.86, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        self.textAlignment = .center
        
    }
    
    
    func setPlaceholder(string: String) {
        self.attributedPlaceholder = NSAttributedString(string: string,
                                                    attributes: [NSForegroundColorAttributeName: self.textColor])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

class AuthViewController: UIViewController {
    let username = FormUITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 125, y: 200, width:250, height: 40))
    let password = FormUITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 125, y: 250, width:250, height: 40))
    let email = FormUITextField(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 125, y: 320, width:250, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "padded")!)
        
        if let token = UserDefaults.standard.object(forKey: "token") {
            processSession(token: token as! String)
        }

        password.isSecureTextEntry = true
        
        username.setPlaceholder(string: "username")
        password.setPlaceholder(string: "password")
        email.setPlaceholder(string: "e-mail")
        view.addSubview(username)
        view.addSubview(email)
        view.addSubview(password)
        
        let auth = Btn(title: "connect", position: CGPoint(x: 0, y: 290))
        view.addSubview(auth)
        auth.centerInParent()
        auth.addTarget(self, action: #selector(authCall), for: .touchDown)
    
        let register = Btn(title: "register", position: CGPoint(x: 0, y: 370))
        view.addSubview(register)
        register.centerInParent()
        register.addTarget(self, action: #selector(registerCall), for: .touchDown)
    }
    
    
    func authCall(_ sender: AnyObject?) {
        authenticate(username: username.text!, password: password.text!.sha256())
    }
    
    func registerCall(_ sender: AnyObject?) {
        register(username: username.text!, password: password.text!.sha256(), email: email.text!)
    }
    
    func authenticate(username: String, password: String) {
        API.post(endpoint: "auth", params: [ "username": username, "password": password ], callback: { data in
            if data["code"].int! == 200 {
                self.processSession(token: data["data"]["token"].string!)
            } else if data["code"].int! == 403 {
                print(data["data"]["field"].string!)
            }
        })
    }
    
    func register(username: String, password: String, email: String) {
        API.post(endpoint: "join", params: [ "username": username, "password": password, "email": email ], callback: { data in
            print(data)
            if data["code"].int! == 200 {
                self.processSession(token: data["data"]["token"].string!)
            } else if data["code"].int! == 403 {
                print(data["data"]["field"].string!)
            }
        })
    }
    
    func processSession(token: String) {
        API.setToken(token: token)
        API.get(endpoint: "player", callback: { data in
            if data["code"].int! == 200 {
                Player(data: data["data"]["player"])
                if data["data"]["player"]["home_base"] != JSON.null {
                    Player.current.homebase = Homebase(data: data["data"]["player"]["home_base"])
                }
                Player.initGridPoints(data: data["data"]["grid_points"])
                TasksManager.initTasks(tasks: data["data"]["tasks"])
                Inventory.initInventory(items: data["data"]["player"]["inventory"])
                Apps.initApps(apps: data["data"]["player"]["apps"])
                DispatchQueue.main.async {
                    self.present(Cardinal(), animated: true, completion: nil)
                }
            }
            
        })
    }
}
