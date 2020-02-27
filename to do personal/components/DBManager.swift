//
//  DBManager.swift
//  to do personal
//
//  Created by Alex Rudoi on 112//20.
//  Copyright © 2020 Alex Rudoi. All rights reserved.
//

import Foundation
import CoreData

class DBManager {
    static var instance = DBManager()
    
    func saveTask(text: String, completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let task = Task(context: managedContext)
        task.taskDesctiption = text
        task.taskStatus = false
        
        do {
            try managedContext.save()
            print("Data saved")
            completion(true)
        } catch {
            print("Failed to save data: ", error.localizedDescription)
            completion(false)
        }
    }
    
    func fetchData(completion: (_ complete: Bool, _ taskArray: [Task]?) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let taskArray = try managedContext.fetch(request) as! [Task]
            print("Data fetched, no issue")
            completion(true, taskArray)
        } catch {
            print("Unable to fetch data: ", error.localizedDescription)
            completion(false, nil)
        }
    }
    
    func deleteData(task: Task) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(task)
        do {
            try managedContext.save()
            print("Data deleted")
        } catch {
            print("Failed to delete data: ", error.localizedDescription)
        }
    }
    
    func updateTask() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        do {
            try managedContext.save()
            print("Data updated2")
        } catch {
            print("Failed to update data: ", error.localizedDescription)
            
        }
    }
    
    func updateTaskStatus(task: Task) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        task.taskStatus = !task.taskStatus
        do {
            try managedContext.save()
            print("Data updated")
        } catch {
            print("Failed to update data: ", error.localizedDescription)
        }
    }
}
