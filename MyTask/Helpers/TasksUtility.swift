//
//  TasksUtility.swift
//  MyTask
//
//  Created by shing ngan on 1/8/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import Foundation

class TasksUtility {
    
    private static let keyForUserDefaults = "tasks"
    
    // Archive
    private static func archive(_ tasks: [[Task]]) -> NSData? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) as NSData
        } catch {
            print("Couldn't write the data")
            return nil
        }
    }
    
    // Fetch
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: keyForUserDefaults) as? Data else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? [[Task]]
        } catch {
            print("Couldn't read the data.")
            return nil
        }
        
    }
    
    // Save
    static func save(_ tasks: [[Task]]) {
        // Call archive function
        let archivedTasks = archive(tasks)
        
        // Put object into user default by using key
        UserDefaults.standard.set(archivedTasks, forKey: keyForUserDefaults)
        UserDefaults.standard.synchronize()
        
    }
    
}
