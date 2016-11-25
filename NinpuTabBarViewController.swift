//
//  TabBarViewController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/21.
//  Copyright © 2016年 K10. All rights reserved.
//

import UIKit

extension UITabBar {
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 66
        return sizeThatFits
    }
}

var tabbutton = UIButton(type: UIButtonType.Custom)

class NinpuTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().titlePositionAdjustment = UIOffsetMake(0, -7)

        self.tabBar.tintColor = UIColor(red: 247/255.0, green: 137/255.0, blue: 149/255.0, alpha: 1.0)
        self.addCenterButtonWithImage(UIImage(named: "help-button")!,//.ResizeUIImage(142, height:105),
                                      highlightImage: nil)//UIImage(named: "help-button-p")!.ResizeUIImage(120, height:90))
        // UITabBar.appearance().backgroundImage = UIImage(named: "base")!//.ResizeUIImage(750, height: 65)
        
        // Do any additional setup after loading the view.
        
        // Tabに設定するViewControllerのインスタンスを生成.
        //print("ninpusettingnavigation will loaded")
        //print(self.storyboard)
        let ninpusettingnavigation : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NinpuSettingNavigation")
        let helpnavigation : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("HelpNavigation")
        let thanksnavigation : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("ThanksNavigation")
        /*
         let myFirstTab: UIViewController = FirstViewController()
         let mySecondTab: UIViewController = SecondViewController()
         let myThirdTab: UIViewController = ThirdViewController()
         */
        // Navication Controllerを生成する.
        /*
         let myFirstViewNavigationController = UINavigationController(rootViewController: myFirstTab)
         let mySecondViewNavigationController = UINavigationController(rootViewController: mySecondTab)
         let myThirdViewNavigationController = UINavigationController(rootViewController: myThirdTab)
         //var secondViewNavigationController = UINavigationController(rootViewController: secondView)
         */
        
        //myFirstTab.title = "ありがとうの声";
        //mySecondTab.title = "妊婦さん";
        //myThirdTab.title = "設定";
       
        // タブを要素に持つArrayの.を作成する.

        // let myTabs = NSArray(objects: myFirstTab, mySecondTab, myThirdTab)

        let myTabs = NSArray(objects: thanksnavigation, helpnavigation, ninpusettingnavigation)
        
        // ViewControllerを設定する.
        self.setViewControllers(myTabs as? [UIViewController], animated: false)
        self.selectedViewController = self.viewControllers![1]
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage: UIImage?){
        tabbutton = UIButton(type: UIButtonType.Custom)
        tabbutton.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
        
        tabbutton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)
        tabbutton.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        tabbutton.setBackgroundImage(buttonImage, forState: UIControlState.Highlighted)
        // tabbutton.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
        tabbutton.addTarget(self, action: #selector(NinpuTabBarViewController.buttonEvent), forControlEvents: UIControlEvents.TouchUpInside)
        
        var heightDifference: CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        
        if (heightDifference < 0){
            tabbutton.center = self.tabBar.center
        }else{
            var center: CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/2.0
            tabbutton.center = center
        }
        
        
        self.view.addSubview(tabbutton)
    }
    
    func buttonEvent() {
        self.selectedIndex = 1
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
        
}