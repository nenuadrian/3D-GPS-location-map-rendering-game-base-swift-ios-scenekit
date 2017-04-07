//
//  Tasks.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class TaskView: UIView, UIGestureRecognizerDelegate {
    let task: Task
    init(task: Task) {
        self.task = task
        let index = TasksManager.tasks.count
        super.init(frame: CGRect(x: Int(UIScreen.main.bounds.width - 50), y: 50 * (index + 1), width: 30, height: 30))
        backgroundColor = UIColor.red
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        
        DispatchQueue.main.async {
            Cardinal.myInstance.view.addSubview(self)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if task.state == .DONE_SERVER {
            task.claim()
        } else {
            print("not done server")
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    
    init(id: String, type: TYPE, remainingSeconds: Int, data: JSON = JSON.null) {
        self.remainingSeconds = remainingSeconds
        self.id = id
        self.type = type
        self.data = data
        self.view = TaskView(task: self)
        self.startClock()
    }
    
    convenience init(task: JSON) {
        self.init(id: task["_id"].string!, type: TYPE(rawValue: task["type"].int!)!, remainingSeconds: task["s"].int!, data: task["data"])
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
            self.timer.invalidate()
            state = .DONE_CLIENT
            API.get(endpoint: "task/\(id)") { (data) in
                if data["code"].int! == 404 {
                    self.view.removeFromSuperview()
                    TasksManager.tasks.removeValue(forKey: self.id)
                } else if data["code"].int! == 518 {
                    self.remainingSeconds = data["data"]["s"].int!
                    self.startClock()
                    self.state = .IN_PROGRESS
                } else if data["code"].int! == 200 {
                    self.state = .DONE_SERVER
                }
            }
        }
    }
    
    @objc func endTask(timer: Timer) {
        state = .DONE_CLIENT
        API.get(endpoint: "task/\(id)") { (data) in
            if data["code"].int! == 404 {
                TasksManager.tasks.removeValue(forKey: self.id)
            } else if data["code"].int! == 518 {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(data["data"]["s"].int!), target: self, selector: #selector(self.endTask), userInfo: nil, repeats: true)
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
    }
    
    func claim() {
        API.post(endpoint: "task/\(id)/claim") { (data) in
            TasksManager.tasks.removeValue(forKey: self.id)
            
            DispatchQueue.main.async {
                self.view.removeFromSuperview()
            }
            
            Logging.info(data: "Claimed task")
        }
    }
}


class TasksManager {
    static var tasks: [String: Task] = [:]
    
    static func initTasks(tasks: JSON) {
        for task in tasks.array! {
            let t =  Task(task: task)
            TasksManager.tasks[t.id] = t
        }
    }
    
    static func addTask(task: Task) {
        TasksManager.tasks[task.id] = task
    }
    
}
