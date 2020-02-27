//
//  Router.swift
//  to do personal
//
//  Created by Alex Rudoi on 152//20.
//  Copyright © 2020 Alex Rudoi. All rights reserved.
//

import UIKit

class Router {
    var navigation: UINavigationController?
    
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func transitionToTaskDetails(task: Task) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddTaskViewController", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        newViewController.router = self
        newViewController.task = task
        navigation?.show(newViewController, sender: nil)
        
    }
}
