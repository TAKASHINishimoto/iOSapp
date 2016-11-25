//
//  HelperViewController.swift
//  OneDayIchizen
//
//  Created by 岩瀬　智亮 on 2016/06/16.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth
import CoreData

var goHelpFlag : Bool = false

class HelperViewController: UIViewController, CBPeripheralManagerDelegate ,CLLocationManagerDelegate {
    
    @IBOutlet weak var compass_background: UIImageView!
    @IBOutlet weak var compas_off: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var headingLabel: UILabel!
    //@IBOutlet weak var needleImg: UIImageView!
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var needleImg: UIImageView!
    @IBOutlet weak var waitingImg: UIImageView!
    var lm: CLLocationManager! = nil
    
    //@IBOutlet weak var ninpuLocation: UILabel!
    //@IBOutlet weak var helperLocation: UILabel!
    
    var ninpuLatitude : Double = 35.665213
    var ninpuLongitude : Double = 139.730011
    var helperLatitude : Double = 0.0
    var helperLongitude : Double = 0.0
    var angle : CGFloat = CGFloat(0.0)
    var phi : Double = 0.0
    var helperAngle : Int? = 0
    var sendAngle : CLBeaconMajorValue = 0
    var sendRadius : CLBeaconMajorValue = 0
    //helperPeripheralManager
    var helperPheripheralManager:CBPeripheralManager!
    var helperBeaconPeripheralData:NSDictionary!
    var distanceByiBeacon : Double = 0
    
    // false -> trueでヘルパーに通知が行く
    var noticeFlag: Bool = false
    var d : Double? = 0.0
    var locationManager: CLLocationManager?
    let manager: CLLocationManager = CLLocationManager()
    // replace uuid and identifier
     let region: CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!, identifier: "onedayichizen")
    //let region: CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "1AE18C1C-6C7B-4AED-B166-4462634DA855")!, identifier: "onedayichizen")
    
    var doctorFlag : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をベージュに
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)
        
        // 最初に表示するボタンの設定
        alertImg.hidden = true
        compass_background.hidden = true
        compas_off.hidden = false
        waitingImg.hidden = false
        needleImg.hidden = true
        
        // PeripheralManagerを定義.
        helperPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        lm = CLLocationManager()
        // 位置情報を取るよう設定
        // ※ 初回は確認ダイアログ表示
        lm.requestAlwaysAuthorization()
        
        lm.delegate = self
        lm.distanceFilter = 1.0 // 1m毎にGPS情報取得
        lm.desiredAccuracy = kCLLocationAccuracyBest // 最高精度でGPS取得
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        // AlwaysAuthorization is required to receive iBeacon
        let status = CLLocationManager.authorizationStatus()
        if status != CLAuthorizationStatus.AuthorizedAlways {
            manager.requestAlwaysAuthorization()
        }
        
        locationManager?.requestAlwaysAuthorization()
        // helperPheripheralManager.startAdvertising(helperBeaconPeripheralData as! [String : AnyObject])
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        helpertabbutton.setBackgroundImage(UIImage(named: "helper-go-p"), forState: UIControlState.Normal)
        helpertabbutton.setBackgroundImage(UIImage(named: "helper-go-p"), forState: UIControlState.Highlighted)
        NSLog("HelperViewWillAppear")
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.writeData("", attribute: UserDataEnum.tmp.rawValue)
        doctorFlag = (appDelegate.readData(UserDataEnum.doctorFlag.rawValue) as! NSNumber) as Bool

        lm.startUpdatingLocation() // 位置情報更新機能起動
        lm.startUpdatingHeading() // コンパス更新機能起動
        manager.startRangingBeaconsInRegion(self.region)

    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        // iBeaconのUUID.
        
        let myProximityUUID = NSUUID(UUIDString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")
        //let myProximityUUID = NSUUID(UUIDString: "1AE18C1C-6C7B-4AED-B166-4462634DA855")
        
        // iBeaconのIdentifier.
        let myIdentifier = "OneDayIchizen"
        
        // Major.
        // 緯度　newLocation.coordinate.latitude
        let myMajor : CLBeaconMajorValue = 65535
        
        // Minor.
        // 経度
        let myMinor : CLBeaconMinorValue = 65535
        
        
        print("(major, minor) = (\(myMajor), \(myMinor))")
        
        // BeaconRegionを定義.
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: myMajor, minor: myMinor, identifier: myIdentifier)
        
        // Advertisingのフォーマットを作成.
        helperBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralDataWithMeasuredPower(nil))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        helperPheripheralManager.stopAdvertising()
        helperLatitude = newLocation.coordinate.latitude
        helperLongitude = newLocation.coordinate.longitude
        let myProximityUUID = NSUUID(UUIDString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")
        // let myProximityUUID = NSUUID(UUIDString: "1AE18C1C-6C7B-4AED-B166-4462634DA855")
        
        let myIdentifier = "OneDayIchizen"

        NSLog(String(doctorFlag))
        NSLog("送る直前A\(helperAngle!)")
        NSLog("送る直前B\(ceil(d!))")
        if(helperAngle! < 0){
            helperAngle! = 360 + helperAngle!
        }
        sendAngle = CLBeaconMajorValue(helperAngle!)
        var intD = distanceByiBeacon
        if intD > 99 {
            intD = 99
        }
        // RadiusにdoctorFlagを載せる
        if doctorFlag {
            intD = 2000 + intD
        } else {
            intD = 1000 + intD
        }
        // RadiusにgoHelpFlagを載せる
        if goHelpFlag {
            intD = 200 + intD
        } else {
            intD = 100 + intD
        }
        
        sendRadius = CLBeaconMajorValue(intD)
        
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: sendRadius, minor: sendAngle, identifier: myIdentifier)
        helperBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralDataWithMeasuredPower(nil))
        
        NSLog("医療フラグ+半径：\(sendRadius)　角度：\(sendAngle)")
        
        if notificationFlag {
            helperPheripheralManager.startAdvertising(helperBeaconPeripheralData as! [String : AnyObject])
            NSLog("テスト\(String(helperBeaconPeripheralData))")
        } else {
            NSLog("notificationFlagがOFFのためBeaconを送らない")
            
        }
        
    }
    
    // コンパスの値を受信
    func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading) {
        //headingLabel.text = String(format:"%f deg",newHeading.magneticHeading)
        
        // コンパスの指す方向を変更
        angle = CGFloat( -(M_PI*(newHeading.magneticHeading/180) ) )
        needleImg.transform = CGAffineTransformMakeRotation(angle + CGFloat(phi))
        
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // checking authorization status for using user location to start or stop monitoring for region
        switch status {
        case CLAuthorizationStatus.AuthorizedAlways:
            print("didChangeAuthorizationStatus: startMonitoringForRegion")
            NSLog("bbbbbbbbbbbbbbbb")
            manager.startMonitoringForRegion(self.region)
        default:
            print("didChangeAuthorizationStatus: stopMonitoringForRegion")
            NSLog("aaaaaaaaaaaaaaaaaa")
            manager.stopMonitoringForRegion(self.region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        // implement whatever you wanna do with recwived iBeacons like
        
        NSLog("didRangeBeacons method is called.")
        print(beacons)
        
        if beacons.count == 0{
            distanceLabel.text = "- -"
            waitingImg.hidden = false
            alertImg.hidden = true
            needleImg.hidden = true
            compass_background.hidden = true
            compas_off.hidden = false
            goHelpFlag = false

        } else if !goHelpFlag {
            
            // Set title, message and alert style
            let alertController = DOAlertController(title: " ", message: "", preferredStyle: .Alert)
            
            // Create the action.
            //let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            // You can add plural action.
            let okAction = DOAlertAction(title: "助けに向かう", style: .Default) { action in
                NSLog("OK action occured.")
                goHelpFlag = true
            }
            
            // Add the action.
            //alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            //alertController.addTextFieldWithConfigurationHandler { textField in
            // text field(UITextField) setting
            // textField.placeholder = "Password"
            //　textField.secureTextEntry = true
            //}
            alertController.overlayColor = UIColor(red:129/255, green:129/255, blue:129/255, alpha:0.95)
            alertController.alertViewBgColor = UIColor(red:75/255, green:75/255, blue:75/255, alpha:0.6)
            alertController.titleFont = UIFont(name: "HiraKakuProN-W3", size: 15.0)
            alertController.titleTextColor = UIColor.whiteColor()
            alertController.messageFont = UIFont(name: "HiraKakuProN-W3", size: 15.0)
            alertController.messageTextColor = UIColor.whiteColor()
            alertController.buttonFont[.Default] = UIFont(name: "HiraKakuProN-W6", size: 15.0)
            alertController.buttonTextColor[.Default] = UIColor.whiteColor()
            alertController.buttonBgColor[.Default] = UIColor(red: 35/255, green:162/255, blue:197/255, alpha:1)
            alertController.buttonBgColorHighlighted[.Default] = UIColor(red:17.5/255, green:81/255, blue:98.5/255, alpha:1)

            // Show alert
            presentViewController(alertController, animated: true, completion: nil)
            

        } else {
            waitingImg.hidden = true
            alertImg.hidden = false
            needleImg.hidden = false
            compass_background.hidden = false
            compas_off.hidden = true
            
            //adding test
            // let test: NinpuViewController = NinpuViewController()
            // test.dragonRadar(20, kakudo: 120)
            
            for(var i = 0; i < beacons.count; i+=1){
                
                if ninpuLatitude > 10000 {
                    continue
                }
                
                ninpuLatitude = floor(helperLatitude*100)/100 + Double(beacons[i].major)/1000000
                ninpuLongitude = floor(helperLongitude*100)/100 + Double(beacons[i].minor)/1000000
                
                
                // beacon電波から距離を算出する方法
                var RSSI : Double = Double(beacons[i].rssi)
                //print("RSSI = \(RSSI)")
                var TxPower : Double = -60.0

                distanceByiBeacon = pow(10.0, (TxPower - RSSI) / 20.0)
                //print("distanceByiBeacon = \(distanceByiBeacon)")
                distanceLabel.text = String(Int(ceil(distanceByiBeacon)))
                
                
//                if ninpuLatitude - helperLatitude > 0.005 {
//                    ninpuLatitude -= 0.01
//                } else if ninpuLatitude - helperLatitude < -0.005 {
//                    ninpuLatitude += 0.01
//                }
//                
//                if ninpuLongitude - helperLongitude > 0.005 {
//                    ninpuLongitude -= 0.01
//                } else if ninpuLongitude - helperLongitude < -0.005 {
//                    ninpuLongitude += 0.01
//                }
//                
//                print(ninpuLatitude)
//                print(ninpuLongitude)
//                print(helperLatitude)
//                print(helperLongitude)
//                
//                // 2人の位置(radian表記)
//                let x_1 : Double = helperLongitude * M_PI / 180.0
//                let y_1 : Double = helperLatitude * M_PI / 180.0
//                let x_2 : Double = ninpuLongitude * M_PI / 180.0
//                let y_2 : Double = ninpuLatitude * M_PI / 180.0
//                
//                // 地球の半径
//                let r : Double = 6378137
//                
//                //ninpuLocation.text = String(format:"%f , %f", ninpuLatitude, ninpuLongitude)
//                //            helperLocation.text = String(format:"%f , %f", helperLatitude, helperLongitude)
//                
//                
//                // 距離と方位を計算（厳密だが近距離では誤差大）
//                // let d : Double = r * acos(sin(y_1)*sin(y_2)+cos(y_1)*cos(y_2)*cos(x_2-x_1))
//                // let phi : Double =  ( M_PI/2 - atan2(cos(y_1)*tan(y_2)-sin(y_1)*cos(x_2-x_1), sin(x_2-x_1) ) ) * 180 / M_PI
//                
//                // 距離と方位を計算（近距離の場合の近似）
//                d = r * sqrt( pow((x_1-x_2) * cos( (y_1+y_2) / 2 ), 2.0) + pow( (y_1-y_2), 2.0 ) )
//                phi = atan2(( (x_2-x_1)*cos((y_1+y_2)/2 ) ) , y_2-y_1 )
//                distanceLabel.text = String(Int(ceil(d!)))
//                //print("aaaaaaaaaaaaa\(String(Int(ceil(d!))))")
//                helperAngle = Int(ceil(phi * 180 / M_PI))
//                needleImg.transform = CGAffineTransformMakeRotation(angle + CGFloat(phi))
//                print("d = \(d)")
            }
        }
        
        // 妊婦さんがhelpボタンを押した時にくる通知
        // implement whatever you wanna do with recwived iBeacons like
        var notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        
        var nearestbeacon : Int = 0
        var nearbeacon : Int = 0
        var farbeacon : Int = 0
        
        for(var i = 0; i < beacons.count; i+=1){
            if beacons[i].proximity.rawValue == 1{
                nearestbeacon += 1
                NSLog("近いよ")
                //notification.alertBody = "近くに妊婦さんが\(String(nearestbeacon))人います" // 通知メッセージ内容
                notification.alertBody = "すぐ近くで妊婦さんが助けを求めています" // 通知メッセージ内容
                notification.alertAction = "OPEN" // ダイアログのボタンラベル
                //UIApplication.sharedApplication().scheduleLocalNotification(notification);
            }else if beacons[i].proximity.rawValue == 2{
                nearbeacon += 1
                NSLog("中くらい")
                //notification.alertBody = "そこそこ遠くに妊婦さんが\(String(nearbeacon))人います" // 通知メッセージ内容
                notification.alertBody = "5m以内で妊婦さんが助けを求めています" // 通知メッセージ内容
                notification.alertAction = "OPEN" // ダイアログのボタンラベル
                //UIApplication.sharedApplication().scheduleLocalNotification(notification);
            }else if beacons[i].proximity.rawValue == 3{
                farbeacon += 1
                NSLog("遠いよ")
                // notification.alertBody = "遠くに妊婦さんが\(String(farbeacon))人います" // 通知メッセージ内容
                notification.alertBody = "10m以内で妊婦さんが助けを求めています" // 通知メッセージ内容
                notification.alertAction = "OPEN" // ダイアログのボタンラベル
                //UIApplication.sharedApplication().scheduleLocalNotification(notification);
            }
        }
        
        print(noticeFlag)
        //ヘルパーが周りにいないときは通知しない
        if(nearestbeacon == 0 && nearbeacon == 0 && farbeacon == 0) {
            //初期化
            noticeFlag = false;
        } else if(!noticeFlag) {
            UIApplication.sharedApplication().scheduleLocalNotification(notification);
            noticeFlag = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSLog("HelperViewWillDisappear")
        NSLog("stopAdvertising")
        helperPheripheralManager.stopAdvertising()
        manager.stopRangingBeaconsInRegion(self.region)
        lm.stopUpdatingLocation() // 位置情報更新機能起動
        lm.stopUpdatingHeading() // コンパス更新機能起動
    }
    
}
