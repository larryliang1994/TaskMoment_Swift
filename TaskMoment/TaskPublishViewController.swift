//
//  TaskPublishViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import SwiftAssetsPickerController
import Photos

class TaskPublishViewController: UITableViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, KPhotoPickerDelegate, MemberDelegate {
  
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    
    @IBOutlet var executorLabel: UILabel!
    @IBOutlet var supervisorLabel: UILabel!
    @IBOutlet var auditorLabel: UILabel!
    
    @IBOutlet var photoCollectionView: UICollectionView!
    
    var executorRow = 0
    var supervisorRow = 0
    var auditorRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        self.navigationItem.title = "发布任务"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        descTextView.delegate = self
        descTextView.textContainerInset = UIEdgeInsetsMake(12, 0, 12, 0)
      
        deadlineLabel.text = UtilBox.getDateFromString(String(NSDate().timeIntervalSince1970), format: Constants.DateFormat.Full)
        startTimeLabel.text = UtilBox.getDateFromString(String(NSDate().timeIntervalSince1970), format: Constants.DateFormat.Full)
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        MemberModel(memberDelegate: self).doGetMember()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if cell.isKindOfClass(TextViewTableViewCell) {
            var height = descTextView.sizeThatFits(CGSizeMake(descTextView.frame.width, CGFloat.max)).height
            height = height > 44 ? height : 44
            return height
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if indexPath.section == 1 {
            let rootListAssets = AssetsPickerController()
            rootListAssets.didSelectAssets = {(assets: Array<PHAsset!>) -> () in
                print(assets)
            }
            let navigationController = UINavigationController(rootViewController: rootListAssets)
            presentViewController(navigationController, animated: true, completion: nil)
        }
        
        if indexPath.section == 2 {
            var which: String
            switch indexPath.row {
            case 0:
                which = "executor"
                break
            case 1:
                which = "supervisor"
                break
            default:
                which = "auditor"
            }
            showMemberPicker(which)
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                showDatePicker("deadline")
            } else {
                showDatePicker("startTime")
            }
        }
        
        cell.selected = false
    }
    
    // 弹出日期选择对话框
    func showDatePicker(which: String) {
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let datePicker = UIDatePicker( )
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        // 初始化显示的时间
        if which == "deadline" {
            datePicker.date = NSDate(timeIntervalSince1970: UtilBox.stringToDate(deadlineLabel.text!, format: Constants.DateFormat.Full))
        } else if which == "startTime" {
            datePicker.date = NSDate(timeIntervalSince1970: UtilBox.stringToDate(startTimeLabel.text!, format: Constants.DateFormat.Full))
        } else {
            datePicker.date = NSDate()
        }
        
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default)
            {(alertAction)->Void in
                if which == "deadline" {
                    self.deadlineLabel.text = UtilBox.getDateFromString(String(datePicker.date.timeIntervalSince1970), format: Constants.DateFormat.Full)
                } else if which == "startTime" {
                    self.startTimeLabel.text = UtilBox.getDateFromString(String(datePicker.date.timeIntervalSince1970), format: Constants.DateFormat.Full)
                }
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 弹出成员选择对话框
    func showMemberPicker(which: String) {
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        let memberPicker = UIPickerView()
        memberPicker.dataSource = self
        memberPicker.delegate = self
        
        // 初始化选中
        switch which {
        case "executor":
            memberPicker.selectRow(executorRow, inComponent: 0, animated: true)
            break
        case "supervisor":
            memberPicker.selectRow(supervisorRow, inComponent: 0, animated: true)
            break
        case "auditor":
            memberPicker.selectRow(auditorRow, inComponent: 0, animated: true)
            break
        default:break
        }
        
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default)
            {(alertAction)->Void in
                let row = memberPicker.selectedRowInComponent(0)
                
                switch which {
                case "executor":
                    self.executorLabel.text = MemberModel.memberList[row].name
                    self.executorRow = row
                    break
                case "supervisor":
                    self.supervisorLabel.text = MemberModel.memberList[row].name
                    self.supervisorRow = row
                    break
                case "auditor":
                    self.auditorLabel.text = MemberModel.memberList[row].name
                    self.auditorRow = row
                    break
                default:break
                    
                }
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.view.addSubview(memberPicker)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        let size = textView.frame.size
        let newSize = textView.sizeThatFits(CGSizeMake(size.width, CGFloat.max))
        
        if size.height != newSize.height {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    // 设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
        return MemberModel.memberList[row].name
    }
    
    // 设置选择框的列数为1列,继承于UIPickerViewDataSource协议
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // 设置选择框的行数为n行，继承于UIPickerViewDataSource协议
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        return MemberModel.memberList.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("taskPublishPhoto", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    // MARK - KPhotoPickerControllerDelegate
    func kPhotoPickerController(didFinishSelectingPhotos photos: [UIImage]) {
        print(photos.count)
    }
    
    func onGetMemberResult(result: Int, info: String) {
        print(result)
    }
}
