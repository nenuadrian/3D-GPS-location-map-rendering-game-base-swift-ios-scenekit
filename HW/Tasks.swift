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
    var id: String!
    var type: String!
    var timer: Timer!
    var finished: Bool = false
    
    init(id: String, type: String, remainingSeconds: Int) {
        self.id = id
        self.type = type
        DispatchQueue.main.async {
        //    self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(remainingSeconds), repeats: true, block: self.endTask)
        }
    }
    
    func endTask(timer: Timer) {
        timer.invalidate()
        finished = true
        TasksManager.done(task: self)
    }
}


class TasksManager {
    static var tasks: [String: Task] = [:]
    
    static func addTask(task: Task) {
        TasksManager.tasks[task.id] = task
    }
    
    static func addTask(task: JSON) {
        TasksManager.addTask(task: Task(id: task["_id"].string!, type: task["type"].string!, remainingSeconds: task["remaining"].int!))
    }
    
    static func done(task: Task) {
        TasksManager.tasks.removeValue(forKey: task.id)
        print("Finished task")
        print(task.type)
    }
}
