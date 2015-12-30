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
        
        Config.Cookie = userDefaults.stringForKey(Constants.Key_Cookie)
        Config.Nickname = userDefaults.stringForKey(Constants.Key_Nickname)
        Config.Mid = userDefaults.stringForKey(Constants.Key_Mid)
        
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(1)
            self.getStarted()
        }
    }
    
    func getStarted() {
        let myStoryBoard = self.storyboard
        
        if Config.Cookie == nil {
            let vc = myStoryBoard?.instantiateViewControllerWithIdentifier(Constants.ID_Login)
            self.presentViewController(vc!, animated: true, completion: nil)
        } else {
            let vc = myStoryBoard?.instantiateViewControllerWithIdentifier(Constants.ID_Company)
            self.presentViewController(vc!, animated: true, completion: nil)
        }
    }
}
