//
//  UserInfoViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import Haneke

class UserInfoViewController: UITableViewController {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        //navBar.translucent = true;
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = "个人中心"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        portraitImageView.hnk_setImageFromURL(NSURL(
            string: Urls.ProtraitMediaCenter + Config.Mid! + ".jpg")!)
        //UtilBox.setShadow(portraitImageView, opacity: 0.2)
        
        nicknameLabel.text = Config.Nickname!
    }

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
