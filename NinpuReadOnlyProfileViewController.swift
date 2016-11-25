//
//  NinpuReadOnlySettingViewController.swift
//  OneDayIchizen
//
//  Created by 長徳　将希 on 2016/06/28.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

class NinpuReadOnlyProfileViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    var myTextField: UITextField = UITextField(frame: CGRectMake(6,0,200,30))
    var gestationalDay: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var hospitalPhoneNumber: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var mailaddress1: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var mailaddress2: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var myAddress: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var myBirthday: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var myBloodType: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var myName: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var myPhoneNumber: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))
    var ninpuAllergy: UITextField! =  UITextField(frame: CGRectMake(6,0,200,30))

    @IBOutlet weak var memoField: UITextView!
    
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var NinpuProfileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.width
        myTextField = UITextField(frame: CGRectMake(20,0,width-30,40))
        gestationalDay =  UITextField(frame: CGRectMake(6,0,width-30,30))
        hospitalPhoneNumber =  UITextField(frame: CGRectMake(6,0,width-30,30))
        myAddress =  UITextField(frame: CGRectMake(6,0,width-30,30))
        myBirthday =  UITextField(frame: CGRectMake(6,0,width-30,30))
        myBloodType =  UITextField(frame: CGRectMake(6,0,width-30,30))
        myName =  UITextField(frame: CGRectMake(6,0,width-30,30))
        myPhoneNumber =  UITextField(frame: CGRectMake(6,0,width-30,30))
        ninpuAllergy =  UITextField(frame: CGRectMake(6,0,width-30,30))
        
        var name = appDelegate.readData(UserDataEnum.myName.rawValue) as! String;
        var bloodtype = appDelegate.readData(UserDataEnum.myName.rawValue) as! String;
        var address = appDelegate.readData(UserDataEnum.myAddress.rawValue) as! String;
        var phonenumber = appDelegate.readData(UserDataEnum.myPhoneNumber.rawValue) as! String;
        var allergy = appDelegate.readData(UserDataEnum.ninpuAllergy.rawValue) as! String;
        var date = appDelegate.readData(UserDataEnum.myBirthday.rawValue)
        var birthday = DateUtils.stringFromDate(date as! NSDate, format: "yyyy/MM/dd") ;
        if(name != "未設定") {
            myName.text = appDelegate.readData(UserDataEnum.myName.rawValue) as! String;
        }
        //myBirthday.text = appDelegate.readData(UserDataEnum.myBirthday.rawValue) as! String;
        if(bloodtype != "未設定") {
            myBloodType.text = appDelegate.readData(UserDataEnum.myBloodType.rawValue) as! String;
        }
        if(address != "未設定") {
            myAddress.text = appDelegate.readData(UserDataEnum.myAddress.rawValue) as! String;
        }
        if(phonenumber != "未設定") {
            myPhoneNumber.text = appDelegate.readData(UserDataEnum.myPhoneNumber.rawValue) as! String;
        }
        if(allergy != "未設定") {
            ninpuAllergy.text = appDelegate.readData(UserDataEnum.ninpuAllergy.rawValue) as! String;
        }
        print (birthday);
        if(birthday != "1000/01/01") {
            myBirthday.text = birthday
        } //gestationalDay = appDelegate.readData(UserDataEnum.gestationalDay.rawValue) as! String;
        memoField.text = appDelegate.readData(UserDataEnum.memo.rawValue) as! String;
        memoField.editable = false
        
        myName.placeholder = info_image_left[0]
        myBirthday.placeholder = info_image_left[1]
        myBloodType.placeholder = info_image_left[2]
        myAddress.placeholder = info_under[0]
        myPhoneNumber.placeholder = info_under[1]
        gestationalDay.placeholder = info_under[2]
        ninpuAllergy.placeholder = info_under[3]
        
        //gestationalDay = appDelegate.readData(UserDataEnum.gestationalDay.rawValue) as! String;

        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        self.view.userInteractionEnabled = true
        gestationalDay.enabled = false
        hospitalPhoneNumber.enabled = false
        myAddress.enabled = false
        myBirthday.enabled = false
        myBloodType.enabled = false
        myName.enabled = false
        myPhoneNumber.enabled = false
        let imageData:NSData = NSUserDefaults.standardUserDefaults().objectForKey("myImage") as! NSData
        NinpuProfileImage.image = UIImage(data:imageData)
        
        if(name != "未設定") {
            myName.text = "名前:"+(appDelegate.readData(UserDataEnum.myName.rawValue) as! String);
        }
        //myBirthday.text = appDelegate.readData(UserDataEnum.myBirthday.rawValue) as! String;
        if(bloodtype != "未設定") {
            myBloodType.text = "血液型:"+(appDelegate.readData(UserDataEnum.myBloodType.rawValue) as! String);
        }
        if(address != "未設定") {
            myAddress.text = "アドレス:"+(appDelegate.readData(UserDataEnum.myAddress.rawValue) as! String);
        }
        if(phonenumber != "未設定") {
            myPhoneNumber.text = "電話番号:"+(appDelegate.readData(UserDataEnum.myPhoneNumber.rawValue) as! String);
        }
        if(allergy != "未設定") {
            ninpuAllergy.text = "アレルギー:"+(appDelegate.readData(UserDataEnum.ninpuAllergy.rawValue) as! String);
        }
        print (birthday);
        if(birthday != "1000/01/01") {
            myBirthday.text = "誕生日:"+birthday
        }
        date = appDelegate.readData(UserDataEnum.gestationalDay.rawValue)
        var gestday = DateUtils.stringFromDate(date as! NSDate, format: "yyyy/MM/dd") ;
        if(gestday != "1000/01/01") {
            gestationalDay.text = "妊娠日:"+gestday
        }
        
    }
    //表示データ
    var info_image_left = ["名前","生年月日", "血液型"]
    var info_under = ["住所","電話番号","妊娠日","アレルギー"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag != 2) {
            return info_image_left.count
        } else {
            return info_under.count
        }
    }
    
    //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell();

        switch tableView.tag {
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("leftTableCell", forIndexPath:indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            //myTextField.placeholder = info_image_left[indexPath.row]
            //cell.addSubview(myTextField)
            switch indexPath.row {
            case 0:
                print ("name")
                cell.addSubview(myName)
            case 1:
                print ("birthday")
                myBirthday.addTarget(self, action: "myTargetFunction:", forControlEvents: UIControlEvents.TouchDown)
                cell.addSubview(myBirthday)
            case 2:
                print ("blood")
                cell.addSubview(myBloodType)
            default:
                break
            }
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("underTableCell", forIndexPath:indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            //myTextField.placeholder = info_under[indexPath.row]
            //cell.addSubview(myTextField)
            switch indexPath.row {
            case 0:
                print("address")
                cell.addSubview(myAddress)
            case 1:
                print ("phone")
                cell.addSubview(myPhoneNumber)
            case 2:
                print("gest")
                cell.addSubview(gestationalDay)
            case 3:
                print("gest")
                cell.addSubview(ninpuAllergy)
            default:
                break
            }
        default:
            break // do nothing
        }
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
}