//
//  NinpuContactViewController.swift
//  OneDayIchizen
//
//  Created by 長徳　将希 on 2016/06/28.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit
class NinpuContactViewController: UIViewController ,UITableViewDataSource ,UITextViewDelegate{
    
    var myTextField: UITextField = UITextField(frame: CGRectMake(20,0,330,40))
    var contactName1: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var contactName2: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var contactName3: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var contactMailaddress1: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var contactMailaddress2: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var contactMailaddress3: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    
    var hospitalName: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var hospitalDoctor: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    var hospitalPhoneNumber: UITextField! =  UITextField(frame: CGRectMake(20,0,330,40))
    
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        myTextField = UITextField(frame: CGRectMake(20,0,width-30,40))
        contactName1 = UITextField(frame: CGRectMake(20,0,width-30,40))
        contactName2 = UITextField(frame: CGRectMake(20,0,width-30,40))
        contactName3 = UITextField(frame: CGRectMake(20,0,width-30,40))
        contactMailaddress1 = UITextField(frame: CGRectMake(20,0,width-30,40))
        contactMailaddress2 = UITextField(frame: CGRectMake(20,0,width-30,40))
        contactMailaddress3 = UITextField(frame: CGRectMake(20,0,width-30,40))
        hospitalName =  UITextField(frame: CGRectMake(20,0,width-30,40))
        hospitalDoctor =  UITextField(frame: CGRectMake(20,0,width-30,40))
        hospitalPhoneNumber =  UITextField(frame: CGRectMake(20,0,width-30,40))
        
        appDelegate.writeData("", attribute: UserDataEnum.tmp.rawValue)
        
        contactName1.placeholder = "名前（お母さん・父など）"
        contactName2.placeholder = "名前（お母さん・父など）"
        contactName3.placeholder = "名前（お母さん・父など）"
        contactMailaddress1.placeholder = "メールアドレス"
        contactMailaddress2.placeholder = "メールアドレス"
        contactMailaddress3.placeholder = "メールアドレス"
        
        hospitalName.placeholder = "病院名"
        hospitalDoctor.placeholder = "担当医指名"
        hospitalPhoneNumber.placeholder = "電話番号"
        
        if appDelegate.readData(UserDataEnum.contactName1.rawValue) as! String != "default"{
            contactName1.text = appDelegate.readData(UserDataEnum.contactName1.rawValue) as! String;
        }else{
            contactName1.text = ""
        }
        if appDelegate.readData(UserDataEnum.contactName2.rawValue) as! String != "default"{
            contactName2.text = appDelegate.readData(UserDataEnum.contactName2.rawValue) as! String;
        }else{
            contactName2.text = ""
        }
        if appDelegate.readData(UserDataEnum.contactName3.rawValue) as! String != "default"{
            contactName3.text = appDelegate.readData(UserDataEnum.contactName3.rawValue) as! String;
        }else{
            contactName3.text = ""
        }
        if appDelegate.readData(UserDataEnum.contactmailaddress1.rawValue) as! String != "default"{
            contactMailaddress1.text = appDelegate.readData(UserDataEnum.contactmailaddress1.rawValue) as! String;
        }else{
            contactMailaddress1.text = ""
        }
        if appDelegate.readData(UserDataEnum.contactmailaddress2.rawValue) as! String != "default"{
            contactMailaddress2.text = appDelegate.readData(UserDataEnum.contactmailaddress2.rawValue) as! String;
        }else{
            contactMailaddress2.text = ""
        }
        if appDelegate.readData(UserDataEnum.contactmailaddress3.rawValue) as! String != "default"{
            contactMailaddress3.text = appDelegate.readData(UserDataEnum.contactmailaddress3.rawValue) as! String;
        }else{
            contactMailaddress3.text = ""
        }
        if appDelegate.readData(UserDataEnum.hospitalName.rawValue) as! String != "default"{
            hospitalName.text = appDelegate.readData(UserDataEnum.hospitalName.rawValue) as! String;
        }else{
            hospitalName.text = ""
        }
        if appDelegate.readData(UserDataEnum.hospitalDoctor.rawValue) as! String != "default"{
            hospitalDoctor.text = appDelegate.readData(UserDataEnum.hospitalDoctor.rawValue) as! String;
        }else{
            hospitalDoctor.text = ""
        }
        if appDelegate.readData(UserDataEnum.hospitalPhoneNumber.rawValue) as! String != "default"{
            hospitalPhoneNumber.text = appDelegate.readData(UserDataEnum.hospitalPhoneNumber.rawValue) as! String;
        }else{
            hospitalPhoneNumber.text = ""
        }

        
        
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        
        
        
    }
    //表示データ
    var info_contact = ["名前","メールアドレス"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 4 {
            return 3
        }else{
            return 2
        }
    }
    
    //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell();
        switch tableView.tag {
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("tableCell1", forIndexPath:indexPath) as UITableViewCell
            switch indexPath.row {
            case 0:
                print ("name")
                cell.addSubview(contactName1)
            case 1:
                print ("address")
                cell.addSubview(contactMailaddress1)
            default:
                break
            }
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("tableCell2", forIndexPath:indexPath) as UITableViewCell
            switch indexPath.row {
            case 0:
                print ("name")
                cell.addSubview(contactName2)
            case 1:
                print ("address")
                cell.addSubview(contactMailaddress2)
            default:
                break
            }
        case 3:
            cell = tableView.dequeueReusableCellWithIdentifier("tableCell3", forIndexPath:indexPath) as UITableViewCell
            switch indexPath.row {
            case 0:
                print ("name")
                cell.addSubview(contactName3)
            case 1:
                print ("address")
                cell.addSubview(contactMailaddress3)
            default:
                break
            }
        case 4:
            cell = tableView.dequeueReusableCellWithIdentifier("tableCell4", forIndexPath:indexPath) as UITableViewCell
            switch indexPath.row {
            case 0:
                print ("name")
                cell.addSubview(hospitalName)
            case 1:
                print ("address")
                cell.addSubview(hospitalDoctor)
            case 2:
                print ("address")
                cell.addSubview(hospitalPhoneNumber)
            default:
                break
            }
        default:
            break // do nothing
        }
        return cell
 
    }
    @IBOutlet weak var pushButton: UIBarButtonItem!
    @IBAction func TouchTestButton(sender: AnyObject) {
    }
    override func viewWillDisappear(animated: Bool) {
        saveData()
    }
    func textFieldDidEndEditing(textField: UITextField) -> Bool {
        print ("textFieldDidEndEditing:" + textField.text!)
        return true
    }
    
    func saveData(){
        appDelegate.writeData(contactName1.text!, attribute: UserDataEnum.contactName1.rawValue)
        appDelegate.writeData(contactName2.text!, attribute: UserDataEnum.contactName2.rawValue)
        appDelegate.writeData(contactName3.text!, attribute: UserDataEnum.contactName3.rawValue)
        appDelegate.writeData(contactMailaddress1.text!, attribute: UserDataEnum.contactmailaddress1.rawValue)
        appDelegate.writeData(contactMailaddress2.text!, attribute: UserDataEnum.contactmailaddress2.rawValue)
        appDelegate.writeData(contactMailaddress3.text!, attribute: UserDataEnum.contactmailaddress3.rawValue)
        appDelegate.writeData(hospitalName.text!, attribute: UserDataEnum.hospitalName.rawValue)
        appDelegate.writeData(hospitalDoctor.text!, attribute: UserDataEnum.hospitalDoctor.rawValue)
        appDelegate.writeData(hospitalPhoneNumber.text!, attribute: UserDataEnum.hospitalPhoneNumber.rawValue)
        
    }
    
    @IBAction func touchSaveButton(sender: AnyObject) {
        saveData()
        self.view.endEditing(true)
    }
}