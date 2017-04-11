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

class TaskManager {
    var tasks: [String: Task] = [:]
    
    func initTasks(tasks: JSON) {
        for task in tasks.array! {
            let t =  Task(task: task)
            self.tasks[t.id] = t
        }
    }
    
    func addTask(task: Task) {
        self.tasks[task.id] = task
    }
    
    func task404(task: Task) {
        task.view.removeFromSuperview()
        task.view = nil
        self.tasks.removeValue(forKey: task.id)
    }
    
    func claim(task: Task) {
        API.post(endpoint: "task/\(task.id)/claim") { (data) in
            self.claimed(task: task)
        }
    }
    
    func claimed(task: Task) {
        tasks.removeValue(forKey: task.id)
        
        DispatchQueue.main.async {
            task.view.removeFromSuperview()
        }
        
        Logging.info(data: "Claimed task")
    }
}
