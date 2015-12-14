//
//  CompanyTableViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/13.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class CompanyTableViewController: UITableViewController {
    var companyList = [[Company]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let companyArray = [
            Company(name: "第一家公司"),
            Company(name: "第二家公司"),
            Company(name: "第三家公司")]
        
        companyList.insert(companyArray, atIndex: 0)
        companyList.insert(companyArray, atIndex: 1)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return companyList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return companyList[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("companyCell", forIndexPath: indexPath)

        cell.textLabel?.text = companyList[indexPath.section][indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "我的公司" : "我加入的公司"
    }
    
    @IBAction func createCompany(sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: nil,
            message: "请填写公司名称",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alert.addAction(UIAlertAction(
            title: "取消",
            style: .Cancel)
            { (action: UIAlertAction) -> Void in
                // do something
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "创建",
            style: .Default)
            { (action: UIAlertAction) -> Void in
                _ = alert.textFields!.first! as UITextField
                
                // do something
            }
        )
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "公司名称"
        }
        
        presentViewController(alert, animated: true, completion: nil)
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
