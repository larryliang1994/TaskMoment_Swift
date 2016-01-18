//
//  MemberViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/29.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import SwiftyJSON

class MemberViewController: UITableViewController, MemberDelegate, AddMemberDelegate {

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
    
    // 跳转前设置代理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController
            destination = navCon.visibleViewController!
        }
        
        if let amvc = destination as? AddMemberViewController {
            amvc.addMemberDelegate = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "成员列表"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemberModel.memberList.count
    }
    
    func onGetMemberResult(result: Int, info: String) {
        if result == Constants.Success {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                sleep(1)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.reloadTableView()
                }
                //self.memberList = MemberModel.memberList
            }
        } else {
            UtilBox.alert(self, message: info)
            
            print(info)
            
            refreshControl?.endRefreshing()
        }
    }
    
    func reloadTableView() {
        tableView.reloadData()
        
        refreshControl?.endRefreshing()
    }
    
    // 添加成员回调
    func didAddMember(member: Member) {
        MemberModel.memberList.append(member)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: MemberModel.memberList.count - 1, inSection: 0)], withRowAnimation: .Fade)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath)

        cell.textLabel?.text = MemberModel.memberList[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "移除"
    }
    
    // 删除成员
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let member = MemberModel.memberList[indexPath.row]
            
            if Config.Mid != Config.CompanyCreator {
                UtilBox.alert(self, message: "只有创建者可以移除成员")
            } else if Config.CompanyCreator == member.mid {
                UtilBox.alert(self, message: "不能移除公司创建者")
            } else {
                let alertController = UIAlertController(title: "提示", message: "真的要移除该成员吗", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "真的", style: UIAlertActionStyle.Default, handler:
                    { (UIAlertAction) -> Void in
                        
                        let params = ["id": member.id!, "mid": member.mid!]
                        AlamofireUtil.requestWithCookie(Urls.DeleteMember, parameters: params, callback:
                            { (result, response) -> Void in
                                if result {
                                    let json = JSON(UtilBox.convertStringToDictionary(response)!)
                                    if json["status"].stringValue == String(Constants.Success) {
                                        MemberModel.memberList.removeAtIndex(indexPath.row)
                                        //self.memberList.removeAtIndex(indexPath.row)
                                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                    } else {
                                        UtilBox.alert(self, message: "操作失败，请重试")
                                    }
                                } else {
                                    UtilBox.alert(self, message: "操作失败，请重试")
                                }
                        })
                })
                let cancelAction = UIAlertAction(title: "假的", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}
