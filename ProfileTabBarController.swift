//
//  ProfileTabBarController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/20.
//  Copyright © 2016年 K10. All rights reserved.
//

import UIKit

// TabBarControllerを継承したクラス
class ProfileTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 自分の持っているViewControllers(ViewControllerの配列)の1番目を選択する。
        self.selectedViewController = self.viewControllers![2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
