//
//  TableViewCell.swift
//  to do personal
//
//  Created by Alex Rudoi on 112//20.
//  Copyright © 2020 Alex Rudoi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var editView: UIView!
    
    var task: Task!
    var router: Router!
    var completion: EmptyClosureType!
    
    override func prepareForReuse() {
        checkboxImage.image = UIImage(named: "checkEmpty")
    }
    
    func config(task: Task, completion: @escaping EmptyClosureType) {
        self.task = task
        self.completion = completion
        checkboxImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
//        let tapGestureEdit = UITapGestureRecognizer(target: self, action: #selector(edit))
        mainView.addGestureRecognizer(tapGesture)
//        editView.addGestureRecognizer(tapGestureEdit)
        setStyle()
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(edit))
//        longPressRecognizer.minimumPressDuration = 0.5
//        longPressRecognizer.delaysTouchesBegan = true
//
//        checkView.addGestureRecognizer(longPressRecognizer)
    }
    
    func setStyle() {
        
        taskLabel.text = task.taskDesctiption
        
//        if overrideUserInterfaceStyle == .dark {
//            print("dark")
//                   taskLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//               } else {
//                   taskLabel.textColor = #colorLiteral(red: 0.06433548859, green: 0.1104220186, blue: 0.1437975888, alpha: 1)
//               }
        
        if task.taskStatus == true {
            mainView.alpha = 0.6
            checkboxImage.image = UIImage(named: "check")
        } else {
            mainView.alpha = 1.0
            checkboxImage.image = UIImage(named: "checkEmpty")
        }
    
//        let background = UIImage(named: "Rectangle 1")
//        var imageView : UIImageView!
//        imageView = UIImageView(frame: mainView.bounds)
//        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = background
////        imageView.center = mainView.center
//        mainView.addSubview(imageView)
//        self.mainView.sendSubviewToBack(imageView)
    }
    
    @objc func tap() {
//        if task.taskStatus {
//            task.taskStatus = false
//            
//        } else {
//            task.taskStatus = true
//            
//        }
        DBManager.instance.updateTaskStatus(task: task)
        
        setStyle()
        completion()
    }
    
   @objc func edit(sender: UILongPressGestureRecognizer) {
//        if sender.state == .began {
//            router.transitionToTaskDetails(task: task)
//        }
    }
    
}
