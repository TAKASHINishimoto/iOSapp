//
//  HelperSettingViewController.swift
//  OneDayIchizen
//
//  Created by 岩瀬　智亮 on 2016/06/16.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//var doctorFlag : Bool = false
var notificationFlag : Bool = true

class HelperSettingViewController: UITableViewController{//, UITableViewDelegate, UITableViewDataSource {

    // Tableで使用する配列を設定する
    // private let myItems: NSArray = ["妊婦さんにヘルパーの通知を送る"]
    // private var myTableView: UITableView!
    // private var myButton: UIButton!
    
    
    @IBOutlet weak var doctorSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!

    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = [" ", " "]
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        helpertabbutton.setBackgroundImage(UIImage(named: "helper-go"), forState: UIControlState.Normal)
        helpertabbutton.setBackgroundImage(UIImage(named: "helper-go"), forState: UIControlState.Highlighted)
        NSLog("HelperSettingViewWillAppear")
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.writeData("", attribute: UserDataEnum.tmp.rawValue)
        let doctorFlag = (appDelegate.readData(UserDataEnum.doctorFlag.rawValue) as! NSNumber) as Bool

        if doctorFlag {
            doctorSwitch.setOn(true, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        self.title = "設定"
        doctorSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        notificationSwitch.addTarget(self, action: Selector("notificationStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        NSLog("HelperSettingViewDidLoad")

    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name:"HelveticaNeue",size:12)
        
        switch section {
        case 0:
            label.text = mySections[section] as! String
        case 1:
            label.text = mySections[section] as! String
        default:
            break // do nothing
        }
        return label
    }
        
    func stateChanged(switchState: UISwitch) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate

        if switchState.on {
            appDelegate.writeData(true ,attribute: UserDataEnum.doctorFlag.rawValue)
            //doctorFlag = true
            NSLog("doctorFlag became true")
        } else {
            appDelegate.writeData(false ,attribute: UserDataEnum.doctorFlag.rawValue)
            //doctorFlag = false
            NSLog("doctorFlag became false")
        }
    }

    func notificationStateChanged(switchState: UISwitch) {
        if switchState.on {
            notificationFlag = true
            NSLog("doctorFlag became true")
        } else {
            notificationFlag = false
            NSLog("doctorFlag became false")
        }
    }
    
    @IBAction func changeNinpu(sender: AnyObject) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.writeData(true, attribute: UserDataEnum.ninpuFlag.rawValue)
        appDelegate.writeData(false, attribute: UserDataEnum.helperFlag.rawValue)
    }


    
    

}