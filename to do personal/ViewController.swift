//
//  ViewController.swift
//  to do personal
//
//  Created by Alex Rudoi on 112//20.
//  Copyright © 2020 Alex Rudoi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var deleteAllBarButton: UIBarButtonItem!
    @IBOutlet weak var noTaskImage: UIImageView!
    
    var taskOne: Task!
    var taskArray: [[Task]] = []
    let cellId = "TableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates() //Setting delegate for Table View
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchyData() //Getting data from database to the Table View
    }
    
    func fetchyData() {
        DBManager.instance.fetchData { (done, taskArray) in
            if done, let allTaskArray = taskArray {
                
                self.taskArray = splitTask(allTaskArray) //Filter tasks to done and undone
                
                //Hide Table View and show Image "No Tasks" when there are no tasks
                if allTaskArray.count > 0 {
                    noTaskImage.isHidden = true
                    tv.isHidden = false
                    tv.reloadData()
                } else {
                    noTaskImage.isHidden = false
                    tv.isHidden = true
                    tv.reloadData()
                }
                
                // Enable button "Delete all" when there are more than 1 task
                if allTaskArray.count > 1 {
                    deleteAllBarButton.isEnabled = true
                } else {
                    deleteAllBarButton.isEnabled = false
                }
                
            }
        }
        
    }
    
    func splitTask(_ tasks: [Task]) -> [[Task]] {
        var result: [[Task]] = []
        
        //Filter tasks to different arrays
        let doneTask = tasks.filter {
            $0.taskStatus == true
        }
        let undoneTask = tasks.filter {
            $0.taskStatus == false
        }
        
        //Add filtered tasks to arrays
        if undoneTask.count > 0 {
            result.append(undoneTask)
        }
        if doneTask.count > 0 {
            result.append(doneTask)
        }
        
        
        return result
    }
    
    func addTask() {
        //Navigate to controller "Add Task"
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddTaskViewController", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        navigationController?.show(newViewController, sender: nil)
    }
    
    func callDelegates() {
        tv.delegate = self
        tv.dataSource = self
        tv.isHidden = true
        tv.allowsSelection = false
        tv.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    @IBAction func addTaped(_ sender: Any) {
        addTask()
    }

    @IBAction func deleteAllButton(_ sender: Any) {
        
        //Creating an alert
        let alertController = UIAlertController(title: "Are you sure you want to delete all tasks?", message: "", preferredStyle: .alert)
        
        //Creating actions
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            UIAlertAction in

            //Delete each task in the task array
            self.taskArray[0].forEach { task in
                DBManager.instance.deleteData(task: task)
            }
            self.taskArray[1].forEach { task in
                DBManager.instance.deleteData(task: task)
            }
            
            //Getting data from database to the Table View
            self.fetchyData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        //Adding actions to the alert
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        let task = taskArray[indexPath.section][indexPath.row]
        
        
        cell.config(task: task, completion: {self.reloadTable()})
        
        return cell
    }
    
    func reloadTable() {
        fetchyData()
        tv.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = self.taskArray[indexPath.section][indexPath.row]
        tableView.reloadData()
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            DBManager.instance.deleteData(task: task)
            self.fetchyData()
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
             let storyBoard: UIStoryboard = UIStoryboard(name: "EditTaskViewController", bundle: nil)
                   let newViewController = storyBoard.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        
            newViewController.task = task
            self.navigationController?.show(newViewController, sender: nil)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        deleteAction.backgroundColor = #colorLiteral(red: 0.7931292808, green: 0, blue: 0.01321882135, alpha: 1)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        if taskArray.count == 1,
            let name = taskArray.first?.first?.taskStatus {
            return name ? "Done" : "Undone"
        }
        
        if section == 1 {
            return "Done"
        } else {
            return "Undone"
        }
    }

}
