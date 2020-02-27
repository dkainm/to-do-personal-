//
//  EditTaskViewController.swift
//  to do personal
//
//  Created by Alex Rudoi on 152//20.
//  Copyright © 2020 Alex Rudoi. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var taskEditedName = ""
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = task.taskDesctiption
    }

    @IBAction func saveButton(_ sender: Any) {
        if textField.text?.isEmpty == true {
            print("Put something in the Text Field")
        } else {
            task.taskDesctiption = textField.text
            DBManager.instance.updateTask()
            navigationController?.popViewController(animated: true)
        }
    }

}
