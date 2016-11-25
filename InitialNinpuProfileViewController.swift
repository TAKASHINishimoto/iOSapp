//
//  InitialNinpuProfileViewController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/17.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

class InitialNinpuProfileViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate ,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
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
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    var info_image_left = ["名前","生年月日", "血液型"]
    var info_under = ["住所","電話番号","妊娠日","アレルギー"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var settingTableOne: UITableView!
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var memo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        //memo.layer.shadowRadius = 2.0
        memo.layer.shadowColor = UIColor.blackColor().CGColor
        memo.layer.shadowOffset = CGSizeMake(0, 1.5)
        memo.layer.shadowOpacity = 0.1
        memo.layer.masksToBounds = false;
        settingTable.layer.shadowColor = UIColor.blackColor().CGColor
        settingTable.layer.shadowOffset = CGSizeMake(0, 1.5)
        settingTable.layer.shadowOpacity = 0.1
        settingTable.layer.masksToBounds = false;
        
        
        
        settingTableOne.layer.shadowColor = UIColor.blackColor().CGColor
        settingTableOne.layer.shadowOffset = CGSizeMake(0, 1.5)
        settingTableOne.layer.shadowOpacity = 0.1
        settingTableOne.layer.masksToBounds = false;
        
        /*
        myName.text = appDelegate.readData(UserDataEnum.myName.rawValue) as! String;
        //myBirthday = appDelegate.readData(UserDataEnum.myBirthday.rawValue) as! String;
        myBloodType.text = appDelegate.readData(UserDataEnum.myBloodType.rawValue) as! String;
        myAddress.text = appDelegate.readData(UserDataEnum.myAddress.rawValue) as! String;
        myPhoneNumber.text = appDelegate.readData(UserDataEnum.myPhoneNumber.rawValue) as! String;
        ninpuAllergy.text = appDelegate.readData(UserDataEnum.ninpuAllergy.rawValue) as! String;
        */
        
        myName.placeholder = info_image_left[0]
        myBirthday.placeholder = info_image_left[1]
        myBloodType.placeholder = info_image_left[2]
        myAddress.placeholder = info_under[0]
        myPhoneNumber.placeholder = info_under[1]
        gestationalDay.placeholder = info_under[2]
        ninpuAllergy.placeholder = info_under[3]
        self.view.userInteractionEnabled = true
        //        self.view.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        var date = appDelegate.readData(UserDataEnum.myBirthday.rawValue)
        var birthday = DateUtils.stringFromDate(date as! NSDate, format: "yyyy/MM/dd") ;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag != 2) {
            return info_image_left.count
        } else {
            return info_under.count
        }
    }
    
    //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        //myTextField = UITextField(frame: CGRectMake(6,0,200,30))
        //myTextField.textColor = UIColor.grayColor()
        var cell = UITableViewCell();
        switch tableView.tag {
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("leftTableCell", forIndexPath:indexPath) as UITableViewCell
            //myTextField.placeholder = info_image_left[indexPath.row]
            //cell.addSubview(myTextField)
            switch indexPath.row {
            case 0:
                print ("name")
                cell.addSubview(myName)
            case 1:
                print ("birthday")
                myBirthday.addTarget(self, action: "myTargetFunction:", forControlEvents: UIControlEvents.AllEvents)
                cell.addSubview(myBirthday)
            case 2:
                print ("blood")
                cell.addSubview(myBloodType)
            default:
                break
            }
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("underTableCell", forIndexPath:indexPath) as UITableViewCell
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
                gestationalDay.addTarget(self, action: "myTargetFunctionGestational:", forControlEvents: UIControlEvents.AllEvents)
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
    @IBOutlet weak var pushButton: UIBarButtonItem!
    @IBAction func TouchTestButton(sender: AnyObject) {
        print ("push button")
        if(myBirthday.text != "") {
            appDelegate.writeData(DateUtils.dateFromString(myBirthday.text!, format: "yyyy/MM/dd"),attribute: UserDataEnum.myBirthday.rawValue)
        }
        if(gestationalDay.text != "") {
            appDelegate.writeData(DateUtils.dateFromString(gestationalDay.text!, format: "yyyy/MM/dd"),attribute: UserDataEnum.gestationalDay.rawValue)
        }
        appDelegate.writeData(myName.text!,attribute: UserDataEnum.myName.rawValue)
        //appDelegate.writeData(myBirthday,attribute: UserDataEnum.myBirthday.rawValue)
        appDelegate.writeData(myBloodType.text!,attribute: UserDataEnum.myBloodType.rawValue)
        appDelegate.writeData(myAddress.text!,attribute: UserDataEnum.myAddress.rawValue)
        appDelegate.writeData(myPhoneNumber.text!,attribute: UserDataEnum.myPhoneNumber.rawValue)
        appDelegate.writeData(ninpuAllergy.text!,attribute: UserDataEnum.ninpuAllergy.rawValue)
        appDelegate.writeData(memo.text!,attribute: UserDataEnum.memo.rawValue)
        
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(ImageView.image!), forKey: "myImage")
        NSUserDefaults.standardUserDefaults().synchronize()

        //testLabel.text = "Touched!" // ここ！
    }
    @IBAction func TouchImage(sender: AnyObject) {
        pickImageFromLibrary()
    }
    override func viewWillDisappear(animated: Bool) {
        /*
         //print ("myName:"+myName.text!)
         appDelegate.writeData(myName.text!,attribute: UserDataEnum.myName.rawValue)
         //appDelegate.writeData(myBirthday,attribute: UserDataEnum.myBirthday.rawValue)
         appDelegate.writeData(myBloodType.text!,attribute: UserDataEnum.myBloodType.rawValue)
         appDelegate.writeData(myAddress.text!,attribute: UserDataEnum.myAddress.rawValue)
         appDelegate.writeData(myPhoneNumber.text!,attribute: UserDataEnum.myPhoneNumber.rawValue)
         //appDelegate.writeData(gestationalDay,attribute: UserDataEnum.gestationalDay.rawValue)
         */
    }
    func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func pickImageFromLibrary() {
        print ("picking")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        print ("picked")
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print (image)
            ImageView.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func myTargetFunction(textField: UITextField) {
        print("呼ばれたよ")
        dateEditing(textField)
    }
    
    func dateEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        myBirthday.text = dateFormatter.stringFromDate(sender.date)
    }
    func myTargetFunctionGestational(textField: UITextField) {
        print("妊娠日が呼ばれたよ")
        dateEditingGestational(textField)
    }
    func dateEditingGestational(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: "datePickerValueChangedGestational:", forControlEvents: UIControlEvents.ValueChanged)
    }
    func datePickerValueChangedGestational(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        gestationalDay.text = dateFormatter.stringFromDate(sender.date)
        
    }
}