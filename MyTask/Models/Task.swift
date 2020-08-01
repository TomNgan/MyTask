//
//  Task.swift
//  MyTask
//
//  Created by shing ngan on 29/7/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    
    var name: String?
    var isDone: Bool?
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
    
    // MARK: - For encoding and decoding task
    
    private let nameKey = "name"
    private let isDoneKey = "isDone"
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: nameKey)
        coder.encode(isDone, forKey: isDoneKey)
    }
    
    required init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: nameKey) as? String,
              let isDone = coder.decodeObject(forKey: isDoneKey) as? Bool
              else { return }
        
        self.name = name
        self.isDone = isDone
    }
    
}
