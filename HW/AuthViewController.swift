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
                DispatchQueue.main.async {
                    self.present(Cardinal(data: data["data"]), animated: true, completion: nil)
                }
            }
            
        })
    }
}
