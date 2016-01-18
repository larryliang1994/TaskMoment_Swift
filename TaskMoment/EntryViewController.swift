//
//  EntryViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/16.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import SwiftyJSON

class EntryViewController: UIViewController {

    @IBOutlet var noNetworkView: UIView!
    @IBOutlet var noNetworkImage: UIImageView!
    @IBOutlet var noNetworkLabel: UILabel!
    @IBOutlet var noNetworkBtn: UIButton!
    @IBOutlet var noNetworkIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        MediaServiceUtil.initMediaService { (result) -> Void in
            if result {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    sleep(1)
                    dispatch_async(dispatch_get_main_queue(), { self.getStarted() })
                }
            }
        }
    }
    
    func getStarted() {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), {
                if Config.Cookie == nil || Config.CID == nil {
                    self.performSegueWithIdentifier(Constants.SegueID.GoToLogin, sender: self)
                } else {
                    if Config.IsReachable == false {
                        self.showNoNetworkScene()
                        self.noNetworkIndicator.stopAnimating()
                    } else {
                        // 获取用户信息
                        self.getUserInfo()
                    }
                }
            })
        }
    }
    
    func getUserInfo() {
        AlamofireUtil.requestWithCookie(Urls.GetUserInfo, parameters: nil)
            { (result, response) -> Void in
                if result {
                    let json = JSON(UtilBox.convertStringToDictionary(response)!)
                    
                    if json["status"].stringValue == String(Constants.Success) {
                        let dataJson = json["data"]
                        Config.Mid = dataJson["id"].stringValue
                        Config.Nickname = dataJson["real_name"].stringValue
                        Config.Portrait = Urls.ProtraitMediaCenter + Config.Mid! + ".jpg"
                        
                        let userDefault = NSUserDefaults.standardUserDefaults()
                        userDefault.setValue(Config.Mid!, forKey: Constants.UserDefaultKey.Mid)
                        userDefault.setValue(Config.Nickname!, forKey: Constants.UserDefaultKey.Nickname)
                        userDefault.setValue(Config.Portrait!, forKey: Constants.UserDefaultKey.Portrait)
                        
                        self.performSegueWithIdentifier(Constants.SegueID.GoToMain, sender: self)
                    } else {
                        self.showNoNetworkScene()
                    }
                } else {
                    self.showNoNetworkScene()
                }
                
                self.noNetworkIndicator.stopAnimating()
        }
    }
    
    func showNoNetworkScene() {
        noNetworkView.alpha = 1
        noNetworkImage.alpha = 1
        noNetworkLabel.alpha = 1
        noNetworkBtn.alpha = 1
        noNetworkBtn.enabled = true
        noNetworkBtn.layer.cornerRadius = 4
        noNetworkBtn.layer.borderWidth = 0.5
    }
    
    @IBAction func reconnect(sender: UIButton) {
        noNetworkIndicator.startAnimating()
        AppDelegate().initService()
        AppDelegate().getNetworkState()
        getStarted()
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
