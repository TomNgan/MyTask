//
//  Task.swift
//  MyTask
//
//  Created by shing ngan on 29/7/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import Foundation

class Task {
    
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
}
