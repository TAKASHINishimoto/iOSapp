//
//  ThanksViewController.swift
//  OneDayIchizen
//
//  Created by 飯塚　洸二郎 on 2016/06/17.
//  Copyright © 2016年 K10. All rights reserved.
//

import Foundation
import UIKit

class ThanksViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initImageView()
        self.title = "ありがとうの声"
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 239/255.0, alpha: 1.0)

    }
 
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        tabbutton.setBackgroundImage(UIImage(named: "help-button"), forState: UIControlState.Normal)
        tabbutton.setBackgroundImage(UIImage(named: "help-button"), forState: UIControlState.Highlighted)
        helpertabbutton.setBackgroundImage(UIImage(named: "helper-go"), forState: UIControlState.Normal)
        helpertabbutton.setBackgroundImage(UIImage(named: "helper-go"), forState: UIControlState.Highlighted)

    }
    
    func initImageView(){
        // UIImage インスタンスの生成
        let image1 : UIImage? = UIImage(named:"./thanks.png")
        
        // UIImageView 初期化
        let imageView = UIImageView(image:image1)
        
        // 画像の中心を設定
        imageView.center = CGPointMake(187.5, 333.5)
        
        // UIImageViewのインスタンスをビューに追加
        self.view.addSubview(imageView)
        
    }
    
}