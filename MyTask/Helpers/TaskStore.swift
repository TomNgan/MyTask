//
//  TaskStore.swift
//  MyTask
//
//  Created by shing ngan on 29/7/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import Foundation

class TaskStore {
    
    // First one is for TODO
    // Second one is for DONE
    var tasks = [[Task](), [Task]()]
    
    func add(_ task: Task, at index: Int, isDone: Bool = false) {
        // section 0 is TODO
        // section 1 is DONE
        let section = isDone ? 1 : 0
        
        tasks[section].insert(task, at: index)
        
    }
    
    @discardableResult func remove(at index: Int, isDone: Bool = false) -> Task {
        // section 0 is TODO
        // section 1 is DONE
        let section = isDone ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
}
