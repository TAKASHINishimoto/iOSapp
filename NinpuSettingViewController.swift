//
//  NinpuSettingViewController.swift
//  OneDayIchizen
//
//  Created by 岩瀬　智亮 on 2016/06/16.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

class NinpuSettingViewController: UITableViewController {
    
    @IBOutlet weak var contactLabel1: UILabel!
    @IBOutlet weak var contactLabel2: UILabel!
    @IBOutlet weak var contactLabel3: UILabel!
    @IBOutlet weak var HospitalNameLabel: UILabel!

    @IBOutlet weak var notifyToFamilySwitch: UISwitch!
    @IBOutlet weak var notifyToHelperSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        NSLog("NinpuSettingViewDidLoad")
        notifyToFamilySwitch.addTarget(self, action: Selector("notifyToFamilyFlagStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        notifyToHelperSwitch.addTarget(self, action: Selector("notifyToHelperFlagStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        soundSwitch.addTarget(self, action: Selector("soundFlagStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool){
        NSLog("NinpuSettingViewWillAppear")
        super.viewWillAppear(animated)
        tabbutton.setBackgroundImage(UIImage(named: "help-button"), forState: UIControlState.Normal)
        tabbutton.setBackgroundImage(UIImage(named: "help-button"), forState: UIControlState.Highlighted)

        
        if appDelegate.readData(UserDataEnum.contactName1.rawValue) as! String != "default"
            && appDelegate.readData(UserDataEnum.contactName1.rawValue) as! String != ""{
            contactLabel1.text = appDelegate.readData(UserDataEnum.contactName1.rawValue) as! String;
        }
        if appDelegate.readData(UserDataEnum.contactName2.rawValue) as! String != "default"
            && appDelegate.readData(UserDataEnum.contactName2.rawValue) as! String != ""{
            contactLabel2.text = appDelegate.readData(UserDataEnum.contactName2.rawValue) as! String;
        }
        if appDelegate.readData(UserDataEnum.contactName3.rawValue) as! String != "default"
            && appDelegate.readData(UserDataEnum.contactName3.rawValue) as! String != ""{
            contactLabel3.text = appDelegate.readData(UserDataEnum.contactName3.rawValue) as! String;
        }
        if appDelegate.readData(UserDataEnum.hospitalName.rawValue) as! String != "default"
            && appDelegate.readData(UserDataEnum.hospitalName.rawValue) as! String != ""{
            HospitalNameLabel.text = appDelegate.readData(UserDataEnum.hospitalName.rawValue) as! String;
        }
    }
    
   let sections = ["", "  連絡先", "  かかりつけ病院", ""]// セクション名を格納しておく
    
    //この関数内でセクションの設定を行う
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name:"HelveticaNeue",size:12)
        switch section {
        case 0:
            label.text = sections[section]
        case 1:
            label.text = sections[section]
        case 2:
            label.text = sections[section]
        case 3:
            label.text = sections[section]
        default:
            break // do nothing
        }
        return label
    }

    func notifyToFamilyFlagStateChanged(switchState: UISwitch) {
        if switchState.on {
            appDelegate.writeData(true ,attribute: UserDataEnum.notifyToFamilyFlag.rawValue)
            //notifyToFamilyFlag = true
            NSLog("notifyToFamilyFlag became true")
        } else {
            appDelegate.writeData(false ,attribute: UserDataEnum.notifyToFamilyFlag.rawValue)
            //notifyToFamilyFlag = false
            NSLog("notifyToFamilyFlag became false")
        }
    }

    func notifyToHelperFlagStateChanged(switchState: UISwitch) {
        if switchState.on {
            appDelegate.writeData(true ,attribute: UserDataEnum.notifyToHelperFlag.rawValue)
            // notifyToHelperFlag = true
            NSLog("notifyToHelperFlag became true")
        } else {
            appDelegate.writeData(false ,attribute: UserDataEnum.notifyToHelperFlag.rawValue)
            // notifyToHelperFlag = false
            NSLog("notifyToHelperFlag became false")
        }
    }

    func soundFlagStateChanged(switchState: UISwitch) {
        if switchState.on {
            appDelegate.writeData(true ,attribute: UserDataEnum.ninpuSoundFlag.rawValue)
            //soundFlag = true
            NSLog("soundFlag became true")
        } else {
            appDelegate.writeData(false ,attribute: UserDataEnum.ninpuSoundFlag.rawValue)
            //soundFlag = false
            NSLog("soundFlag became false")
        }
    }

    override func viewWillDisappear(animated: Bool) {
        
    }

    @IBAction func changeHelper(sender: AnyObject) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.writeData(false, attribute: UserDataEnum.ninpuFlag.rawValue)
        appDelegate.writeData(true, attribute: UserDataEnum.helperFlag.rawValue)
    }

    
}