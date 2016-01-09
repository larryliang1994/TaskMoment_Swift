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
     
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 0.5)
        navBar.translucent = true;
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = "公司列表"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
                
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let company = companyList[indexPath.section][indexPath.row]
        
        Config.CID = company.cid!
        Config.CompanyName = company.name!
        Config.CompanyCreator = company.creator!
        Config.CompanyBackground  = Urls.BackgroundMediaCenter + String(Config.CID!) + ".jpg";
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(Config.CID, forKey: Constants.UserDefaultKey.Cid)
        userDefaults.setObject(Config.CompanyName, forKey: Constants.UserDefaultKey.CompanyName)
        userDefaults.setObject(Config.CompanyCreator, forKey: Constants.UserDefaultKey.CompanyCreator)
        userDefaults.setObject(Config.CompanyBackground, forKey: Constants.UserDefaultKey.CompanyBackground)
        
        self.performSegueWithIdentifier(Constants.SegueID.ChooseCompany, sender: self)
    }
    
}
