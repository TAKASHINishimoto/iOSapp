//
//  TabBarController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/17.
//  Copyright © 2016年 K10. All rights reserved.
//
import UIKit

// TabBarControllerを継承したクラス
class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 自分の持っているViewControllers(ViewControllerの配列)の1番目を選択する。
        self.selectedViewController = self.viewControllers![1]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
