//
//  Task.swift
//  HackerC
//
//  Created by Adrian Nenu on 10/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class Task {
    enum TYPE: Int {
        case NONE
        case HOME_BASE
        case CRAFT
    }
    
    enum STATE: Int {
        case IN_PROGRESS
        case DONE_CLIENT
        case DONE_SERVER
    }
    
    let id: String
    let type: TYPE
    var timer: Timer!
    var state: STATE = .IN_PROGRESS
    var data: JSON = JSON.null
    var view: TaskView!
    var remainingSeconds: Int = 0
    var totalSeconds: Int = 0
    
    init(id: String, type: TYPE, totalSeconds: Int, remainingSeconds: Int, data: JSON = JSON.null) {
        self.remainingSeconds = max(0, remainingSeconds)
        self.totalSeconds = totalSeconds
        self.id = id
        self.type = type
        self.data = data
        self.view = TaskView(task: self)
        self.startClock()
    }
    
    convenience init(task: JSON) {
        self.init(id: task["_id"].string!, type: TYPE(rawValue: task["type"].int!)!, totalSeconds: task["ts"].int!, remainingSeconds: task["s"].int!, data: task["data"])
    }
    
    func startClock() {
        DispatchQueue.main.async {
            if self.timer != nil && self.timer.isValid {
                self.timer.invalidate()
            }
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.ticker), userInfo: nil, repeats: true)
        }
    }
    
    @objc func ticker(_: Timer) {
        remainingSeconds = remainingSeconds - 1
        Logging.info(data: "Task \(self.id) \(self.remainingSeconds)")
        if remainingSeconds <= 0 {
            view.set(progress: CGFloat(1))
            
            self.timer.invalidate()
            state = .DONE_CLIENT
            API.get(endpoint: "task/\(id)") { (data) in
                if data["code"].int! == 404 {
                    Cardinal.player.taskManager.task404(task: self)
                } else if data["code"].int! == 518 {
                    self.remainingSeconds = data["data"]["s"].int!
                    self.startClock()
                    self.state = .IN_PROGRESS
                } else if data["code"].int! == 200 {
                    self.state = .DONE_SERVER
                    Logging.info(data: "Done task server")
                    switch self.type {
                    case Task.TYPE.HOME_BASE:
                        Cardinal.player.newHomebase(homebase: Homebase(coords: Utils.vectorFrom(json: self.data["coords"])))
                        break
                    default: ()
                    }
                }
            }
        } else {
            let progress: Float = (100.0 - (Float(remainingSeconds) / (Float(totalSeconds) / 100.0))) / 100.0
            view.set(progress: CGFloat(progress))
        }
    }
}
