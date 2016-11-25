//
//  NavigationBarController.swift
//  TestTabbedProject
//
//  Created by 岩瀬　智亮 on 2016/06/21.
//  Copyright © 2016年 岩瀬　智亮. All rights reserved.
//

import UIKit

class NavigationBarController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor(red: 247/255.0, green: 137/255.0, blue: 149/255.0, alpha: 1.0)
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // Status bar white font
        // self.navigationBar.barStyle = UIBarStyle.Black
        //self.navigationBar.backgroundColor = UIColor(red: 247/255.0, green: 137/255.0, blue: 149/255.0, alpha: 1.0)
        //self.navigationBar.tintColor = UIColor(red: 247/255.0, green: 137/255.0, blue: 149/255.0, alpha: 1.0)
    }
}