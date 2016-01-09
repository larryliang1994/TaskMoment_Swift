//
//  MemberViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/29.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class MemberViewController: UITableViewController, MemberDelegate {

    var memberList = [Member]() {
        didSet {
            tableView.reloadData()
            
            refreshControl?.endRefreshing()
        }
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()

        MemberModel(memberDelegate: self).doGetMember()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        //navBar.translucent = true;
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = "成员管理"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        refresh()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "成员列表"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func onGetMemberResult(result: Int, info: String) {
        if result == Constants.Success {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                sleep(1)
                self.memberList = MemberModel.memberList
            }
        } else {
            let alert = UIAlertController(
                title: nil,
                message: info,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            alert.addAction(UIAlertAction(
                title: "好的",
                style: .Cancel)
                { (action: UIAlertAction) -> Void in }
            )
            
            presentViewController(alert, animated: true, completion: nil)
            
            print(info)
            
            refreshControl?.endRefreshing()
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath)

        cell.textLabel?.text = memberList[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}
