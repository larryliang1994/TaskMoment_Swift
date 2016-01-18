//
//  PreferenceViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class PreferenceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
    }
    
    func initNavBar() {
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = "设置"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        let backBtn = UIBarButtonItem()
        self.navigationItem.backBarButtonItem = backBtn
        navBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.selected = false
        
        switch indexPath.section {
        // 功能
        case 0:
            switch indexPath.row {
            // 切换公司
            case 1:
                self.performSegueWithIdentifier(Constants.SegueID.SwitchCompany, sender: self)
                break
            default: break
            }
           
        // 其它
        case 1:
            switch indexPath.row {
            // 分享
            case 0:
                let activiyItems = [Constants.ShareText, Constants.ShareUrl]
                
                let activityVC = UIActivityViewController(activityItems: activiyItems, applicationActivities: nil)
                
                activityVC.excludedActivityTypes =
                    [UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]
                
                self.presentViewController(activityVC, animated: true, completion: nil)
                break
                
            case 2:
                self.performSegueWithIdentifier(Constants.SegueID.About, sender: self)
                break
            default: break
            }
        // 账号
        case 2:
            switch indexPath.row {
            // 注销
            case 0:
                let alert = UIAlertController(
                    title: nil,
                    message: "真的要注销吗?",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                alert.addAction(UIAlertAction(
                    title: "真的",
                    style: .Default)
                    { (action: UIAlertAction) -> Void in
                        UtilBox.clearUserDefaults()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.performSegueWithIdentifier(Constants.SegueID.Logout, sender: self)
                    }
                )
                
                alert.addAction(UIAlertAction(
                    title: "假的",
                    style: .Cancel)
                    { (action: UIAlertAction) -> Void in }
                )
                
                self.presentViewController(alert, animated: true, completion: nil)
                break
            default: break
            }
            break
            
        default: break
        }
    }
}
