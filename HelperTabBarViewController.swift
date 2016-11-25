//
//  HelperTabBarViewController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/21.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    // Resizeするクラスメソッド.
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        
        // コンテキストに自身に設定された画像を描画する.
        self.drawInRect(CGRectMake(0, 0, width, height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

var helpertabbutton = UIButton(type: UIButtonType.Custom)

class HelperTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(red: 247/255.0, green: 137/255.0, blue: 149/255.0, alpha: 1.0)
        self.addCenterButtonWithImage(UIImage(named: "helper-go")!, highlightImage: nil)
        //UITabBar.appearance().backgroundImage = UIImage(named: "base")!.ResizeUIImage(600, height: 49)
        
        // Do any additional setup after loading the view.
        
        // Tabに設定するViewControllerのインスタンスを生成.
        var ninpusettingnavigation : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("HelperSettingNavigation")
        var helpnavigation : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("CompassNavigation")
        var thanksnavigation : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("ThanksNavigation")
    
        // タブを要素に持つArrayの.を作成する.
        // let myTabs = NSArray(objects: myFirstTab, mySecondTab, myThirdTab)
        let myTabs = NSArray(objects: thanksnavigation, helpnavigation, ninpusettingnavigation)
        
        // ViewControllerを設定する.
        self.setViewControllers(myTabs as? [UIViewController], animated: false)
        self.selectedViewController = self.viewControllers![1]
        //self.tabBarItem = UITabBarItem(title: "hoge", image: UIImage(named: "hoge.png", tag: 0)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage: UIImage?){
        helpertabbutton = UIButton(type: UIButtonType.Custom)
        helpertabbutton.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
        
        helpertabbutton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)
        helpertabbutton.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        helpertabbutton.setBackgroundImage(buttonImage, forState: UIControlState.Highlighted)
        // helpertabbutton.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
        helpertabbutton.addTarget(self, action: #selector(HelperTabBarViewController.buttonEvent), forControlEvents: UIControlEvents.TouchUpInside)
        
        var heightDifference: CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        
        if (heightDifference < 0){
            helpertabbutton.center = self.tabBar.center
        }else{
            var center: CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/2.0
            helpertabbutton.center = center
        }
        
        
        self.view.addSubview(helpertabbutton)
        
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