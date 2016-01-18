//
//  AboutViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
        
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = true
    }
    
    // 初始化其它view
    func initView() {
        let buildInfo: NSDictionary = NSBundle.mainBundle().infoDictionary!
        //print(buildInfo)
        
        versionLabel.text = String(buildInfo.objectForKey("CFBundleShortVersionString")!)
    }
    
    // 初始化NavigationBat
    func initNavBar() {
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        //navBar.translucent = true;
        
        self.navigationItem.title = "关于"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
}
