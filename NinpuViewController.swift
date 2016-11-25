//
//  ViewController.swift
//  OneDayIchizen
//
//  Created by 長徳　将希 on 2016/06/07.
//  Copyright © 2016年 K10. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import CoreData
import Pulsator
import MessageUI
import AVFoundation

var ninpuHelpButtonFlag : Bool = false

class NinpuViewController: UIViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    //    @IBOutlet weak var helper: UILabel!
    @IBOutlet weak var helpButtonBlue: UIButton!
    @IBOutlet weak var raderImage: UIImageView!
    @IBOutlet weak var alartImage: UIImageView!
    @IBOutlet weak var stopHelpSendButton: UIButton!
    @IBOutlet weak var topLabel1: UILabel!
    @IBOutlet weak var topLabel2: UILabel!
    @IBOutlet weak var topLabel3: UILabel!
    @IBOutlet weak var topNumLabel: UILabel!
    @IBOutlet weak var showProfileButton: UIButton!
    
    @IBOutlet weak var numHelper: UILabel!
    
    
    // LocationManager.
    var myPheripheralManager:CBPeripheralManager!
    var myBeaconPeripheralData:NSDictionary!
    // 青赤判定(false:赤, true:青)
    var helpFlag : Bool = false
    var mailFlag : Bool = false
    // false -> true で通知が行く
    var noticeFlag: Bool = false
    var locationManager: CLLocationManager?
    let manager: CLLocationManager = CLLocationManager()
    // replace uuid and identifier
    let region: CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")!, identifier: "OneDayIchizen")
    let pulsator = Pulsator()
    // ヘルパーの合計人数
    var total : Int = 0
    var ninpuHankei : Double = 0
    var ninpuAngle : Double = 0
    var doctorFlag : Int = 0
    var gohelpFlag : Int = 0
    // メールで送る緯度と経度
    var lat : Double = 0
    var lon : Double = 0
    var hamonFlag : Bool = false
    
    //再生用のplayerを設定
    var musicPlayer:AVAudioPlayer!
    let music_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("alart1", ofType: "mp3")!)
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        helpButtonBlue.setBackgroundImage(UIImage(named: "pushedbutton"), forState: UIControlState.Highlighted)
        
        // PeripheralManagerを定義.
        myPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        // from myReceiver.swift
        manager.delegate = self
        // AlwaysAuthorization is required to receive iBeacon
        let status = CLLocationManager.authorizationStatus()
        if status != CLAuthorizationStatus.AuthorizedAlways {
            manager.requestAlwaysAuthorization()
        }
        
        locationManager?.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //let ntvc = NinpuTabBarViewController()
        //ntvc.view.subviews[2].removeFromSuperview()
        //ntvc.addCenterButtonWithImage(UIImage(named: "help-button-p")!, highlightImage: nil)
        tabbutton.setBackgroundImage(UIImage(named: "help-button-p"), forState: UIControlState.Normal)
        tabbutton.setBackgroundImage(UIImage(named: "help-button-p"), forState: UIControlState.Highlighted)
        
        NSLog("NinpuViewWillAppear")

        locationManager?.startUpdatingHeading()
        locationManager?.startUpdatingLocation()
        manager.startRangingBeaconsInRegion(self.region)

        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        //updateninpuHelpButtonFlag(true)
        //3
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            print (results)
            for obj:AnyObject in results {
                let name:String? = obj.valueForKey(UserDataEnum.myAddress.rawValue) as? String
                print (name);
                //helpFlag = name!
            }
            print (results.count)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        helpFlag = ninpuHelpButtonFlag
        
        //reloadninpuHelpButtonFlag()
        //print("helpflag: \(helpFlag)")
        updateButtonView()
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        //NSLog("peripheralManagerDidUpdateStateが呼ばれました")
        // iBeaconのUUID.
        let myProximityUUID = NSUUID(UUIDString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")
        
        // iBeaconのIdentifier.
        let myIdentifier = "OneDayIchizen"
        
        // Major.
        // 緯度
        let myMajor : CLBeaconMajorValue = 65535
        
        // Minor.
        // 経度
        let myMinor : CLBeaconMinorValue = 65535
        
        //print("(major, minor) = (\(myMajor), \(myMinor))")
        
        // BeaconRegionを定義.
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: myMajor, minor: myMinor, identifier: myIdentifier)
        
        // Advertisingのフォーマットを作成.
        myBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralDataWithMeasuredPower(nil))
        
    }
    
    func reloadninpuHelpButtonFlag(){
        
    }
    
    func updateninpuHelpButtonFlag(flag: Bool){
        //let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let myContext: NSManagedObjectContext = appDelegate.managedObjectContext
        //let myEntity: NSEntityDescription! = NSEntityDescription.entityForName("UserData", inManagedObjectContext: myContext)
        //let newData = UserData(entity: myEntity, insertIntoManagedObjectContext: myContext)
        
        //newData.ninpuHelpButtonFlag = flag
        
        //appDelegate.saveContext()
        ninpuHelpButtonFlag = flag
        
        //print("flag: \(Bool(newData.ninpuHelpButtonFlag!))")
        print("flag: \(ninpuHelpButtonFlag)")
        
    }
    
    func buttonPushedEvent(){
        if !helpFlag {
            // Advertisingを毎秒発信.
            myPheripheralManager.startAdvertising(myBeaconPeripheralData as! [String : AnyObject])
            NSLog("startAdvertising.")
            raderImage.hidden = false
            alartImage.hidden = false
            stopHelpSendButton.hidden = false
            showProfileButton.hidden = false
            
            helpButtonBlue.hidden = true
            topLabel1.hidden = true
            topLabel2.hidden = true
            topLabel3.hidden = true
            topNumLabel.hidden = true
            
            helpFlag = true
            updateninpuHelpButtonFlag(true)
            
            // 位置情報を送信する
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()

            
            mailFlag = true

            
            var soundFlag : Bool
            appDelegate.writeData("", attribute: UserDataEnum.tmp.rawValue)
            soundFlag = (appDelegate.readData(UserDataEnum.ninpuSoundFlag.rawValue) as! NSNumber) as Bool
            
            if soundFlag == true{
                //音を再生する
                do {
                    if musicPlayer != nil {
                        //停止部分
                        musicPlayer.play()
                        musicPlayer = nil
                    }
                    else{
                        //動作部分
                        musicPlayer = try AVAudioPlayer(contentsOfURL: music_data)
                        musicPlayer.play()
                    }
                
                }catch let error as NSError {
                    //エラーをキャッチした場合
                    print(error)
                }
                catch{
                    print("Music Play Error")
                }
            }
            
        } else {
            pulsator.stop()
            myPheripheralManager.stopAdvertising()
            NSLog("stopAdvertising.")
            raderImage.hidden = true
            alartImage.hidden = true
            stopHelpSendButton.hidden = true
            showProfileButton.hidden = true
            
            helpButtonBlue.hidden = false
            topLabel1.hidden = false
            topLabel2.hidden = false
            topLabel3.hidden = false
            topNumLabel.hidden = false
            
            helpFlag = false
            updateninpuHelpButtonFlag(false)
            
            //音の再生を止める
            if musicPlayer != nil && musicPlayer.playing{
                musicPlayer.stop()
            }
        }
    }
    
    
    @IBAction func touchHelpButton(sender: AnyObject) {
        buttonPushedEvent()
    }
    
    func updateButtonView(){
        if helpFlag {
            raderImage.hidden = false
            alartImage.hidden = false
            stopHelpSendButton.hidden = false
            showProfileButton.hidden = false
            
            helpButtonBlue.hidden = true
            topLabel1.hidden = true
            topLabel2.hidden = true
            topLabel3.hidden = true
            topNumLabel.hidden = true
            
        } else {
            raderImage.hidden = true
            alartImage.hidden = true
            stopHelpSendButton.hidden = true
            showProfileButton.hidden = true
            
            helpButtonBlue.hidden = false
            topLabel1.hidden = false
            topLabel2.hidden = false
            topLabel3.hidden = false
            topNumLabel.hidden = false
        }
    }
    
    //　メーラを終了する関数
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
        case MFMailComposeResultCancelled:
            print("Email Send Cancelled")
            break
        case MFMailComposeResultSaved:
            print("Email Saved as a Draft")
            break
        case MFMailComposeResultSent:
            print("Email Sent Successfully")
            break
        case MFMailComposeResultFailed:
            print("Email Send Failed")
            break
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // from myReceiver.swift
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // checking authorization status for using user location to start or stop monitoring for region
        switch status {
        case CLAuthorizationStatus.AuthorizedAlways:
            //print("didChangeAuthorizationStatus: startMonitoringForRegion")
            //NSLog("bbbbbbbbbbbbbbbb")
            manager.startMonitoringForRegion(self.region)
        default:
            //print("didChangeAuthorizationStatus: stopMonitoringForRegion")
            //NSLog("aaaaaaaaaaaaaaaaaa")
            manager.stopMonitoringForRegion(self.region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
    
        NSLog("didRangeBeacons")
        
        // implement whatever you wanna do with recwived iBeacons like
        var notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        
        var nearestbeacon : Int = 0
        var nearbeacon : Int = 0
        var farbeacon : Int = 0
        
        let views = self.view.subviews
        for myView in views {
            //print ("View:\(myView.description)")
            //print (myView.tag)
            if myView.isKindOfClass(UIImageView) && myView.tag == 100 {
                myView.removeFromSuperview()
                ///self.view.addSubview(myLabel)
                //print ("delete image")
            }
        }
        
        
        for(var i = 0; i < beacons.count; i+=1){
            
            // beacon受信
            ninpuHankei = Double(beacons[i].major)
            ninpuAngle = Double(beacons[i].minor)
            // doctorFlagを抜き取る
            print("処理前の半径 = \(ninpuHankei)")
            
            let registory : Double = floor(ninpuHankei / 1000.0)
            if (registory == 1) {
                doctorFlag = 1
                ninpuHankei -= 1000
            } else if (registory == 2) {
                doctorFlag = 2
                ninpuHankei -= 2000
            }
            
            let registory2 : Double = floor(ninpuHankei / 100.0)
            if (registory2 == 1) {
                gohelpFlag = 1
                ninpuHankei -= 100
            } else if (registory2 == 2) {
                gohelpFlag = 2
                ninpuHankei -= 200
            }
            
            
            print("半径　＝　\(ninpuHankei)、　角度　＝　\(ninpuAngle)、 ドクターフラグ ＝　\(doctorFlag)、　助けに行くよフラグ　＝　\(gohelpFlag)")
            
            if(helpFlag == true) {
                // ドラゴンレーダ上にヘルパの位置を表示させる
                dragonRadar(ninpuHankei, kakudo: ninpuAngle)
                
            }
            
            appDelegate.writeData("", attribute: UserDataEnum.tmp.rawValue)
            let notifyToHelperFlag = (appDelegate.readData(UserDataEnum.notifyToHelperFlag.rawValue) as! NSNumber) as Bool

            if notifyToHelperFlag {
                if beacons[i].proximity.rawValue == 1{
                    nearestbeacon += 1
                    // NSLog("近いよ")
                    notification.alertBody = "近くにヘルパーが\(String(nearestbeacon))人います" // 通知メッセージ内容
                    notification.alertAction = "OPEN" // ダイアログのボタンラベル
                    //UIApplication.sharedApplication().scheduleLocalNotification(notification);
                }else if beacons[i].proximity.rawValue == 2{
                    nearbeacon += 1
                    // NSLog("中くらい")
                    notification.alertBody = "そこそこ遠くにヘルパーが\(String(nearbeacon))人います" // 通知メッセージ内容
                    notification.alertAction = "OPEN" // ダイアログのボタンラベル
                    //UIApplication.sharedApplication().scheduleLocalNotification(notification);
                }else if beacons[i].proximity.rawValue == 3{
                    farbeacon += 1
                    // NSLog("遠いよ")
                    notification.alertBody = "遠くにヘルパーが\(String(farbeacon))人います" // 通知メッセージ内容
                    notification.alertAction = "OPEN" // ダイアログのボタンラベル
                    //UIApplication.sharedApplication().scheduleLocalNotification(notification);
                }
            }
        }
        
        total = nearbeacon + nearestbeacon + farbeacon
        //        print("周りにヘルパーさんは\(total)人います")
        
        //ヘルパーが周りにいないときは通知しない
        if(nearestbeacon == 0 && nearbeacon == 0 && farbeacon == 0) {
            // none
            //ヘルパーが周りにいて1秒前に通知していない時に通知する
            noticeFlag = false
        } else if(!noticeFlag) {
            UIApplication.sharedApplication().scheduleLocalNotification(notification);
            noticeFlag = true
            // 1時間ごとにnoticeFlagをfalseにする
            //NSTimer.scheduledTimerWithTimeInterval(3600, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        }
        topNumLabel.text = String(nearestbeacon + nearbeacon + farbeacon)
        
    }
    
    // 位置情報が変わるごとに更新される
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        NSLog("didUpdateToLocation")
        //NSLog(String(newLocation.coordinate.latitude,newLocation.coordinate.longitude))
        // 少数第3から6までを抜き取る
        // 緯度と経度をString型にで変数に格納
        var latitude : String = String(newLocation.coordinate.latitude)
        var longitude : String = String(newLocation.coordinate.longitude)
        
        
        lat = Double(newLocation.coordinate.latitude)
        lon = Double(newLocation.coordinate.longitude)
        
        
        print("(緯度, 経度) = (\(latitude), \(longitude))")
        print("------------------------------------------------------------------")
        
        // 緯度を小数点第3から6桁だけlatitudeに格納
        var fromIdx = latitude.startIndex.advancedBy(5)
        var toIdx = latitude.endIndex.advancedBy(8-latitude.characters.count)
        latitude = latitude.substringWithRange(fromIdx...toIdx)
        
        // 緯度を小数点第3から6桁だけlongitudeに格納
        fromIdx = longitude.startIndex.advancedBy(6)
        toIdx = longitude.endIndex.advancedBy(9-longitude.characters.count)
        longitude = longitude.substringWithRange(fromIdx...toIdx)
        
        //print("(変換前の緯度の四桁, 変換前の経度の四桁) = (\(latitude), \(longitude))")
        
        // 型変換
        let ido : CLBeaconMajorValue = CLBeaconMajorValue(latitude)!
        let keido : CLBeaconMajorValue = CLBeaconMajorValue(longitude)!
        
        // 情報をbeaconで送信する
        // iBeaconのUUID.
        let myProximityUUID = NSUUID(UUIDString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")
        
        // iBeaconのIdentifier.
        let myIdentifier = "OneDayIchizen"
        
        // Major.
        // 緯度　newLocation.coordinate.latitude
        let myMajor : CLBeaconMajorValue = ido
        // Minor.
        // 経度
        let myMinor : CLBeaconMinorValue = keido
        
        // BeaconRegionを定義.
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: myMajor, minor: myMinor, identifier: myIdentifier)
        
        // Advertisingのフォーマットを作成.
        myBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralDataWithMeasuredPower(nil))
        //        print("(緯度の四桁, 経度の四桁) = (\(ido), \(keido))\n")
        if(helpFlag == true){
            myPheripheralManager.stopAdvertising()
            myPheripheralManager.startAdvertising(myBeaconPeripheralData as? [String : AnyObject])
        }

        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }
        
        let notifyToFamilyFlag = (appDelegate.readData(UserDataEnum.notifyToFamilyFlag.rawValue) as! NSNumber) as Bool
        
        if (notifyToFamilyFlag == true && mailFlag == true) {
            // Coredataの読み出し(mail)
            //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //let managedContext = appDelegate.managedObjectContext
            let mailAddress1 : String = appDelegate.readData(UserDataEnum.contactmailaddress1.rawValue) as! String
            let mailAddress2 : String = appDelegate.readData(UserDataEnum.contactmailaddress2.rawValue) as! String
            print("TO :  \(mailAddress1), \(mailAddress2)")
            
            // write
            //mailAddress1 = String(appDelegate.writeData("test1@gmail.com",attribute: UserDataEnum.mailaddress1.rawValue))
            //mailAddress2 = String(appDelegate.writeData("test2@gmail.com",attribute: UserDataEnum.mailaddress2.rawValue))
            print("TO :  \(mailAddress1), \(mailAddress2)")
            // メールの詳細設定
            let mailViewController = MFMailComposeViewController()
            let toRecipients = ["\(mailAddress1)"]
            let CcRecipients = ["\(mailAddress2)"]
            let BccRecipients = [""]
            
            // LocationManagerの呼び出し
            //lat = Double(locationManager!)
            
            
            mailViewController.mailComposeDelegate = self
            mailViewController.setSubject("[一日一善] HELPボタンが押されました!")
            // Toアドレスの表示
            mailViewController.setToRecipients(toRecipients)
            // Ccアドレスの表示
            mailViewController.setCcRecipients(CcRecipients)
            // Bccアドレスの表示
            mailViewController.setBccRecipients(BccRecipients)
            // 本文
            let body : String = "ヘルプボタンが押されました。\n 押された場所をURLで確認してください。"
            //let location : String = "http://map.yahoo.co.jp/maps?lat=\(lat)&lon=\(lon)"
            let location : String = "http://www.geocoding.jp/?q=\(lon)+\(lat)"
            // 本文作成
            mailViewController.setMessageBody("\(body) \n\n \(location)", isHTML: false)
            self.presentViewController(mailViewController, animated: true, completion: nil)

            mailFlag = false
        }
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        // 一時間後に初期化する
    }
    
    
    func onUpdate(timer : NSTimer){
        //noticeFlag = false;
        
        if (hamonFlag == false) {
            pulsator.numPulse = 5
            pulsator.animationDuration = 6
            let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
            pulsator.position = CGPoint(x: raderImage.image!.size.width/2, y: raderImage.image!.size.height/2)
            pulsator.backgroundColor = UIColor(red: 255, green: 255, blue: 197, alpha: 0.6).CGColor
            NSLog("x:\(myBoundSize.width/2)")
            pulsator.radius = 240.0
            //pulsator.pulseInterval = 1
            raderImage.layer.addSublayer(pulsator)
            pulsator.start()
            print("hamon")
            
            hamonFlag = true
        }
        
    }
    
    // var doctorFlag : Int = 1
    // ドラゴンレーダ上にヘルパの位置を表示させるための関数
    func dragonRadar(han : Double, kakudo : Double) {
        // π
        let pi = CGFloat(M_PI)
        // 開始の角度
        let start : CGFloat = 0.0
        // 終了の角度
        let end : CGFloat = pi * 2.0
        // 細かい描写
        let path : UIBezierPath = UIBezierPath();
        let hankei : CGFloat = CGFloat(han)
        let kakudo : CGFloat = CGFloat(kakudo)
        let theta : CGFloat = CGFloat(kakudo/180*pi)
        var r : CGFloat = CGFloat(0)
        // 描画を隠す
        if(50 <= han){
            r = 8 / 10 * self.view.frame.width/2
        } else if(10 <= han && han < 50){
            r = self.view.frame.width/2 * 2/5 + self.view.frame.width/2 * 1/5  * (hankei-10)/40
        } else if(0 <= han && han < 10) {
            r = self.view.frame.width/2 * 2/5 * hankei / 10
        }
        // print("r = \(r), x = \(r*cos(theta)), y = \(r*sin(theta))")
        
        // ドラゴンボールを表示
        let view: UIImageView = UIImageView()
        // UIImage インスタンスの生成
        var image1:UIImage? = UIImage(named:"helper-nomal")
        
        if (doctorFlag == 1) {
            image1 = UIImage(named:"helper-nomal")
            if (gohelpFlag == 2) {
                image1 = UIImage(named:"./helper-emergency.png")
            }
        } else if (doctorFlag == 2){
            image1 = UIImage(named:"./medical-man.png")
            if (gohelpFlag == 2) {
                image1 = UIImage(named:"./medicalman-emergency.png")
            }
        }
        // UIImageView 初期化
        let imageView = UIImageView(image:image1)
        // 画像の中心を設定
        imageView.tag = 100
        imageView.center = CGPointMake(self.view.frame.width/2+r*cos(theta), self.view.frame.height/2-r*sin(theta))
        self.view.addSubview(imageView)
//        
//        if (hamonFlag == false) {
//            pulsator.numPulse = 5
//            pulsator.animationDuration = 6
//            let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
//            pulsator.position = CGPoint(x: raderImage.image!.size.width/2, y: raderImage.image!.size.height/2)
//            pulsator.backgroundColor = UIColor(red: 255, green: 255, blue: 197, alpha: 0.6).CGColor
//            NSLog("x:\(myBoundSize.width/2)")
//            pulsator.radius = 240.0
//            //pulsator.pulseInterval = 1
//            raderImage.layer.addSublayer(pulsator)
//            pulsator.start()
//            print("hamon")
//            
//            hamonFlag = true
//        }
    }
    // UIImageを全て消す関数
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
    }

    override func viewWillDisappear(animated: Bool) {
        NSLog("NinpuViewWillDisappear")
        locationManager?.stopUpdatingHeading()
        locationManager?.stopUpdatingLocation()
        manager.stopRangingBeaconsInRegion(self.region)
    }
}


