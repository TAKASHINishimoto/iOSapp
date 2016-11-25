//
//  AppDelegate.swift
//  beacon
//
//  Created by 西本　高志 on 2016/06/07.
//  Copyright © 2016年 西本　高志. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    // 位置情報利用の許可を求めるコード
    var locationManager: CLLocationManager!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let isNinpu = readData(UserDataEnum.ninpuFlag.rawValue)
        
        if ( isNinpu is NSString ) {
            print("NoData")
        } else {
            print(String(isNinpu as! Bool))
            var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var ninpuflag = isNinpu as! Bool
            if ninpuflag {
               
                var mainViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("NinpuTabBarView")
//                //self.navigationController = UINavigationController(rootViewController: mainViewController)
//
//                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//                let ninpuView : NinpuTabBarViewController = NinpuTabBarViewController()
                print("ninpu")
                self.window?.rootViewController = mainViewController

            } else {
//                let helperView = HelperTabBarViewController()
//                self.window?.rootViewController = helperView
                print("helper")
                var mainViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("HelperTabBarView")
                self.window?.rootViewController = mainViewController

                
            }
        }

        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//        if let tabvc = self.window!.rootViewController as? UITabBarController  {
//            tabvc.selectedIndex = 2 // 0 が一番左のタブ
//        }

        return true
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Sound]), categories: nil))
        
        self.backgroundTaskID = application.beginBackgroundTaskWithExpirationHandler(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        }
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        application.endBackgroundTask(self.backgroundTaskID)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "OneDayIchizen.hoge" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("UserData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    let ENTITY_NAME = "UserData"
    
    // データ登録/更新
    func writeData(content: AnyObject,attribute: String) -> Bool{
        
        var ret = false
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 検索して見つかったらアップデートする
                let obj = results[0] as! NSManagedObject
                print (attribute)
                let txt = try obj.valueForKey(attribute)
                obj.setValue(content, forKey: attribute)
                print("UPDATE \(txt) TO \(content)")
                appDelegate.saveContext()
                ret = true
                
            }else{
                // 見つからなかったら新規登録
                let entity: NSEntityDescription! = NSEntityDescription.entityForName(ENTITY_NAME, inManagedObjectContext: context)
                let obj = UserData(entity: entity, insertIntoManagedObjectContext: context)
                obj.setValue(content, forKey: attribute)
                print("INSERT \(content)")
                do {
                    try context.save()
                } catch let error as NSError {
                    // エラー処理
                    print("INSERT ERROR:\(error.localizedDescription)")
                }
                ret = true
            }
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    func readData(attribute: String) -> AnyObject{
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 見つかったら読み込み
                let obj = results[0] as! NSManagedObject
                let content = obj.valueForKey(attribute)
                print("READ:\(content)")
                return content!
            }
            //return results.valueForKey(attribute)
        } catch let error as NSError {
            // エラー処理
            print("READ ERROR:\(error.localizedDescription)")
            
        }

        return "NoData"
    }
    
    
}