//
//  CompanyTableViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/13.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class CompanyTableViewController:UITableViewController, CompanyDelegate {
    
    private var companyList = [[Company]]() {
        didSet {
            tableView.reloadData()
            
            refreshControl?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        refresh()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    func refresh(){
        refreshControl?.beginRefreshing()
        
        CompanyModel(companyDelegate: self).getCompany()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return companyList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            { (action: UIAlertAction) -> Void in }
        )
        
        alert.addAction(UIAlertAction(
            title: "创建",
            style: .Default)
            { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first! as UITextField
                
                if textField.text != nil {
                    CompanyModel(companyDelegate: self).doCreateCompany(textField.text!)
                }
            }
        )
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "公司名称"
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func onGetCompanyResult(result: Int, info: String, companyList: [[Company]]?) {
        if result == Constants.Success {
            self.companyList = companyList!
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
    
    func onCreateCompanyResult(result: Int, info: String){
        if result == Constants.Success {
            refresh()
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
