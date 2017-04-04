//
//  Tasks.swift
//  HW
//
//  Created by Adrian Nenu on 28/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    
    var id: String!
    var type: TYPE!
    var timer: Timer!
    var state: STATE = .IN_PROGRESS
    var data: JSON = JSON.null
    
    init(id: String, type: TYPE, remainingSeconds: Int, data: JSON = JSON.null) {
        print("\(id)  \(remainingSeconds)")

        self.id = id
        self.type = type
        self.data = data
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(max(1, remainingSeconds)), target: self, selector: #selector(self.endTask), userInfo: nil, repeats: false)
        }
    }
    
    convenience init(task: JSON) {
        self.init(id: task["_id"].string!, type: TYPE(rawValue: task["type"].int!)!, remainingSeconds: task["s"].int!, data: task["data"])
    }
    
    @objc func endTask(timer: Timer) {
        state = .DONE_CLIENT
        API.get(endpoint: "task/\(id!)") { (data) in
            if data["code"].int! == 404 {
                TasksManager.tasks.removeValue(forKey: self.id!)
            } else if data["code"].int! == 518 {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(data["data"]["s"].int!), target: self, selector: #selector(self.endTask), userInfo: nil, repeats: true)
                self.state = .IN_PROGRESS
            } else if data["code"].int! == 200 {
                self.state = .DONE_SERVER
                TasksManager.done(task: self)
            }
        }
    }
}


class TasksManager {
    static var tasks: [String: Task] = [:]
    
    static func initTasks(tasks: JSON) {
        for task in tasks.array! {
            TasksManager.addTask(task: Task(task: task))
        }
    }
    
    static func addTask(task: Task) {
        TasksManager.tasks[task.id] = task
    }
    
    static func done(task: Task) {
        TasksManager.tasks.removeValue(forKey: task.id)
        
        switch task.type! {
        case Task.TYPE.HOME_BASE:
            Player.homebase = Homebase(coords: Vector2(x: Scalar(task.data["coords"][0].double!), y: Scalar(task.data["coords"][1].double!)))
            break
        case Task.TYPE.CRAFT:
            break
        default:
            break
        }
        print("Finished task")
        print(task.type)
    }
}
