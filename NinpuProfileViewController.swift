//
//  NinpuProfileViewController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/17.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}
class NinpuProfileViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    let datePickerView:UIDatePicker = UIDatePicker()
    @IBOutlet weak var tableView: UITableView!
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
    
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var MemoField: UITextView!
    
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        myTextField = UITextField(frame: CGRectMake(20,0,width-30,40))
        gestationalDay =  UITextField(frame: CGRectMake(6,0,width-30,30))
        hospitalPhoneNumber =  UITextField(frame: CGRectMake(6,0,width-30,30))
        mailaddress1 =  UITextField(frame: CGRectMake(6,0,width-30,30))
        mailaddress2 =  UITextField(frame: CGRectMake(6,0,width-30,30))
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
        }
        date = appDelegate.readData(UserDataEnum.gestationalDay.rawValue)
        var gestday = DateUtils.stringFromDate(date as! NSDate, format: "yyyy/MM/dd") ;
        if(gestday != "1000/01/01") {
            gestationalDay.text = gestday
        }
        MemoField.text = appDelegate.readData(UserDataEnum.memo.rawValue) as! String;

        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        self.view.userInteractionEnabled = true
//        self.view.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        
        myName.placeholder = info_image_left[0]
        myBirthday.placeholder = info_image_left[1]
        myBloodType.placeholder = info_image_left[2]
        myAddress.placeholder = info_under[0]
        myPhoneNumber.placeholder = info_under[1]
        gestationalDay.placeholder = info_under[2]
        ninpuAllergy.placeholder = info_under[3]
        
        let imageData:NSData = NSUserDefaults.standardUserDefaults().objectForKey("myImage") as! NSData
        ImageView.image = UIImage(data:imageData)
    }
    override func viewWillAppear(animated:Bool) {
        tabbutton.setBackgroundImage(UIImage(named: "help-button"), forState: UIControlState.Normal)
        tabbutton.setBackgroundImage(UIImage(named: "help-button"), forState: UIControlState.Highlighted)
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
//        myTextField = UITextField(frame: CGRectMake(6,0,200,30))
//        myTextField.textColor = UIColor.grayColor()
        var cell = UITableViewCell();
//        switch tableView.tag {
//            
//        case 1:
//            cell = tableView.dequeueReusableCellWithIdentifier("leftTableCell", forIndexPath:indexPath) as UITableViewCell
//            myTextField.becomeFirstResponder()
//            myTextField.placeholder = info_image_left[indexPath.row]
//            if(indexPath.row == 1) {
//             myTextField.addTarget(self, action: "myTargetFunction:", forControlEvents: UIControlEvents.TouchDown)
//            }
//            cell.addSubview(myTextField)
//        case 2:
//            cell = tableView.dequeueReusableCellWithIdentifier("underTableCell", forIndexPath:indexPath) as UITableViewCell
//            myTextField.placeholder = info_under[indexPath.row]
//            cell.addSubview(myTextField)
//        default:
//            break // do nothing
//        }
        
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
        appDelegate.writeData(myName.text!,attribute: UserDataEnum.myName.rawValue)
        if(myBirthday.text != "") {
            appDelegate.writeData(DateUtils.dateFromString(myBirthday.text!, format: "yyyy/MM/dd"),attribute: UserDataEnum.myBirthday.rawValue)
        }
        if(gestationalDay.text != "") {
            appDelegate.writeData(DateUtils.dateFromString(gestationalDay.text!, format: "yyyy/MM/dd"),attribute: UserDataEnum.gestationalDay.rawValue)
        }
        appDelegate.writeData(myBloodType.text!,attribute: UserDataEnum.myBloodType.rawValue)
        appDelegate.writeData(myAddress.text!,attribute: UserDataEnum.myAddress.rawValue)
        appDelegate.writeData(myPhoneNumber.text!,attribute: UserDataEnum.myPhoneNumber.rawValue)
        appDelegate.writeData(ninpuAllergy.text!,attribute: UserDataEnum.ninpuAllergy.rawValue)
        appDelegate.writeData(MemoField.text!,attribute: UserDataEnum.memo.rawValue)
        //appDelegate.writeData(,attribute: UserDataEnum.myBirthday.rawValue)
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(ImageView.image!), forKey: "myImage")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.view.endEditing(true)
        //testLabel.text = "Touched!" // ここ！
        self.view.endEditing(true)
    }
    func getUIImageFromUIView(myUIView:UIView) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(myUIView.frame.size, true, 0);//必要なサイズ確保
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        CGContextTranslateCTM(context, -myUIView.frame.origin.x, -myUIView.frame.origin.y);
        myUIView.layer.renderInContext(context);
        let renderedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return renderedImage;
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
    func textFieldDidEndEditing(textField: UITextField) -> Bool {
        print ("textFieldDidEndEditing:" + textField.text!)
        return true
    }

    
//     func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
//        print("ああああああああああ")
//        print(info_image_left[indexPath.row])
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)行目を選択")
        
    }
    
    func myTargetFunction(textField: UITextField) {
        print("呼ばれたよ")
        dateEditing(textField)
    }
    func myTargetFunctionGestational(textField: UITextField) {
        print("妊娠日が呼ばれたよ")
        dateEditingGestational(textField)
    }
    @IBAction func TouchImage(sender: AnyObject) {
        pickImageFromLibrary()
    }
    
    func dateEditing(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    func dateEditingGestational(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: "datePickerValueChangedGestational:", forControlEvents: UIControlEvents.ValueChanged)
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
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        myBirthday.text = dateFormatter.stringFromDate(sender.date)
        
    }
    func datePickerValueChangedGestational(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        gestationalDay.text = dateFormatter.stringFromDate(sender.date)
        
    }
}