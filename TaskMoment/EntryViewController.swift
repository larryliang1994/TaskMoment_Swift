//
//  EntryViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/16.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Config.Random = String(arc4random_uniform(100000))

        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        Config.Cookie = userDefaults.stringForKey(Constants.UserDefaultKey.Cookie)
        Config.Nickname = userDefaults.stringForKey(Constants.UserDefaultKey.Nickname)
        Config.Mid = userDefaults.stringForKey(Constants.UserDefaultKey.Mid)
        Config.CID = userDefaults.stringForKey(Constants.UserDefaultKey.Cid)
        Config.CompanyName = userDefaults.stringForKey(Constants.UserDefaultKey.CompanyName)
        Config.CompanyBackground = userDefaults.stringForKey(Constants.UserDefaultKey.CompanyBackground)
        Config.CompanyCreator = userDefaults.stringForKey(Constants.UserDefaultKey.CompanyCreator)
        
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), { self.getStarted() })
        }
    }
    
    func getStarted() {
        self.dismissViewControllerAnimated(true, completion:nil)
        
        if Config.Cookie == nil || Config.CID == nil {
            self.performSegueWithIdentifier(Constants.SegueID.GoToLogin, sender: self)
        } else {
            self.performSegueWithIdentifier(Constants.SegueID.GoToMain, sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("HomePage")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("HomePage")
    }
}
