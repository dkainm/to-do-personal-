//
//  AddTaskViewController.swift
//  to do personal
//
//  Created by Alex Rudoi on 112//20.
//  Copyright © 2020 Alex Rudoi. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTv: UITextField!
    
    var taskName = ""
    var router: Router!
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        if taskTv.text?.isEmpty == true {
            print("Put something in the Text Field")
        } else {
            taskName = taskTv.text!
            DBManager.instance.saveTask(text: taskName) { (done) in
                if done {
                    print("We need to return now")
                    navigationController?.popViewController(animated: true)
                } else {
                    print("Try again")
                }
            }
        }
    
    }
    
}
