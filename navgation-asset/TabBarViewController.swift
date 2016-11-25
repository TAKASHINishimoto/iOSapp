//
//  TabBarViewController.swift
//  Tab Bar Center v2
//
//  Created by Jorge Crisóstomo Palacios on 2/20/15.
//  Copyright (c) 2015 videmor. All rights reserved.
//

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


class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCenterButtonWithImage(UIImage(named: "help-button")!.ResizeUIImage(120, height:90),
                                      highlightImage: nil)//UIImage(named: "help-button-p")!.ResizeUIImage(120, height:90))
        UITabBar.appearance().backgroundImage = UIImage(named: "base")!.ResizeUIImage(600, height: 49)
       
        // Do any additional setup after loading the view.
        
        // Tabに設定するViewControllerのインスタンスを生成.
        let myFirstTab: UIViewController = FirstViewController()
        let mySecondTab: UIViewController = SecondViewController()
        let myThirdTab: UIViewController = ThirdViewController()
        
        // Navication Controllerを生成する.
        let myFirstViewNavigationController = UINavigationController(rootViewController: myFirstTab)
        let mySecondViewNavigationController = UINavigationController(rootViewController: mySecondTab)
        let myThirdViewNavigationController = UINavigationController(rootViewController: myThirdTab)
        //var secondViewNavigationController = UINavigationController(rootViewController: secondView)
        myFirstTab.title = "ありがとうの声";
        mySecondTab.title = "妊婦さん";
        myThirdTab.title = "設定";
        
        // タブを要素に持つArrayの.を作成する.
        // let myTabs = NSArray(objects: myFirstTab, mySecondTab, myThirdTab)
        let myTabs = NSArray(objects: myFirstViewNavigationController, mySecondViewNavigationController, myThirdViewNavigationController)
        
        // ViewControllerを設定する.
        self.setViewControllers(myTabs as? [UIViewController], animated: false)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage: UIImage?){
        let button = UIButton(type: UIButtonType.Custom)
        button.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
        
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        // button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
        button.addTarget(self, action: #selector(TabBarViewController.buttonEvent), forControlEvents: UIControlEvents.TouchUpInside)
        
        var heightDifference: CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        
        if (heightDifference < 0){
            button.center = self.tabBar.center
        }else{
            var center: CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/2.0
            button.center = center
        }
        
        
        self.view.addSubview(button)
        
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