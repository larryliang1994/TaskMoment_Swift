//
//  TimelineViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/28.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController, TimelineDelegate {

    private var taskList = [Task]() {
        didSet {
            tableView.reloadData()
            
            refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 0.5)
        navBar.translucent = true;
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = Config.CompanyName! + "的任务圈"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]

        refresh()
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        
        TimelineModel(timelineDelegate: self).doPullTimeline(Int(NSDate().timeIntervalSince1970), type: "refresh")
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : taskList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("timelineHeaderCell", forIndexPath: indexPath) as! TimelineHeaderTableViewCell
            cell.initHeader()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("timelineBodyCell", forIndexPath: indexPath) as! TimelineTableViewCell
            
            cell.task = taskList[indexPath.row]
            
            return cell
        }
    }
    
    func onPullTimelineResult(result: Int, info: String) {
        if result == Constants.Success || result == Constants.NoMore{
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                sleep(1)
                self.taskList = TimelineModel.taskList
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
