//
//  InitialSettingViewController.swift
//  OneDayIchizen
//
//  Created by 岩瀬　智亮 on 2016/06/16.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

class InitialSettingViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
    }
    
    @IBAction func helperSelected(sender: AnyObject) {
        appDelegate.writeData(true, attribute: UserDataEnum.helperFlag.rawValue)
        appDelegate.writeData(false, attribute: UserDataEnum.ninpuFlag.rawValue)
        print("helper")
    }
    @IBAction func ninpuSelected(sender: AnyObject) {
        appDelegate.writeData(true, attribute: UserDataEnum.ninpuFlag.rawValue)
        appDelegate.writeData(false, attribute: UserDataEnum.helperFlag.rawValue)
        print("ninpu")
    }

}