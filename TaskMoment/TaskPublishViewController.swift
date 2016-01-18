//
//  TaskPublishViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController

class TaskPublishViewController: UITableViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TaskDelegate {
  
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    
    @IBOutlet var executorLabel: UILabel!
    @IBOutlet var supervisorLabel: UILabel!
    @IBOutlet var auditorLabel: UILabel!
    
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var gradeSegment: UISegmentedControl!
    
    var task: Task?
    
    var executorRow = -1
    var supervisorRow = -1
    var auditorRow = -1
    
    var photos = [UIImage]()
    var selecedPhotos = [DKAsset]()
    
    var taskPublishDelegate: TaskPublishDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        
        initView()
        
        photos.append(UIImage(named: "add_picture")!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = true
    }
    
    // 初始化其它view
    func initView() {
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        descTextView.delegate = self
        descTextView.textContainerInset = UIEdgeInsetsMake(12, 0, 12, 0)
        
        deadlineLabel.text = UtilBox.getDateFromString(String(NSDate().timeIntervalSince1970), format: Constants.DateFormat.Full)
        startTimeLabel.text = UtilBox.getDateFromString(String(NSDate().timeIntervalSince1970), format: Constants.DateFormat.Full)
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.backgroundColor = UIColor.whiteColor()
    }
    
    // 初始化NavigationBar
    func initNavBar() {
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        self.navigationItem.title = "发布任务"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    // 点击发布按钮
    @IBAction func publish(sender: UIBarButtonItem) {
        // 先检查输入
        let errorInfo = verifyInput()
        if errorInfo == nil {
            let grade = String(gradeSegment.selectedSegmentIndex + 1)
            let desc = descTextView.text
            let executor = MemberModel.memberList[executorRow].mid!
            let supervisor = MemberModel.memberList[supervisorRow].mid!
            let auditor = MemberModel.memberList[auditorRow].mid!
            
            let deadline = String(Int(UtilBox.stringToDate(deadlineLabel.text!, format: Constants.DateFormat.Full)))
            let startTime = String(Int(UtilBox.stringToDate(startTimeLabel.text!, format: Constants.DateFormat.Full)))
            
            task = Task()
            task?.grade = grade
            task?.desc = desc
            task?.executor = Int(executor)
            task?.supervisor = Int(supervisor)
            task?.auditor = Int(auditor)
            task?.deadline = deadline
            task?.startTime = startTime
            
            TaskModel(taskDelegate: self).doPublishTask(grade, desc: desc,
                executor: executor, supervisor: supervisor, auditor: auditor,
                deadline: deadline, startTime: startTime)
        } else {
            UtilBox.alert(self, message: errorInfo!)
        }
    }
    
    func onPublishTaskResult(result: Int, info: String) {
        if result == Constants.Success {
            task?.id = Int(info)
            task?.nickname = Config.Nickname
            //task?.pictures =
            task?.sendState = photos.count > 0 ? Task.SendState.Sending : Task.SendState.Success
            task?.portraitUrl = Urls.ProtraitMediaCenter + Config.Mid! + ".jpg"
            task?.mid = Int(Config.Mid!)
            task?.createTime = String(Int(NSDate().timeIntervalSince1970))
            task?.auditResult = 1
            
            photos.removeLast()
            taskPublishDelegate?.didPublishTask(task!, photos: photos)
            
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    // 检查是否有未填入的项
    func verifyInput() -> String? {
        if descTextView.text == nil || descTextView.text == "" {
            return "请填入任务描述"
        } else if executorRow == -1 {
            return "请选择执行者"
        } else if supervisorRow == -1 {
            return "请选择监督者"
        } else if auditorRow == -1 {
            return "请选择审核者"
        } else {
            return nil
        }
    }
    
    // 行高度计算
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if cell.isKindOfClass(TextViewTableViewCell) {
            var height = descTextView.sizeThatFits(CGSizeMake(descTextView.frame.width, CGFloat.max)).height
            height = height > 44 ? height : 44
            return height
        } else if (indexPath.section == 1){
            var row: Int?
            if photos.count <= 3 {
                row = 1
            } else if photos.count >= 7 {
                row = 3
            } else {
                row = 2
            }
            let space = (row! - 1) * 10 + 16
            let height = CGFloat(row! * 55 + space)
            return height
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    // 行点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
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
            memberPicker.selectRow(executorRow == -1 ? 0 : executorRow, inComponent: 0, animated: true)
            break
        case "supervisor":
            memberPicker.selectRow(supervisorRow == -1 ? 0 : supervisorRow, inComponent: 0, animated: true)
            break
        case "auditor":
            memberPicker.selectRow(auditorRow == -1 ? 0 : auditorRow, inComponent: 0, animated: true)
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
    
    // 任务描述高度计算
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
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // 设置选择框的行数为n行，继承于UIPickerViewDataSource协议
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        return MemberModel.memberList.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemNum = photos.count
        return itemNum == 10 ? itemNum - 1 : itemNum
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("taskPublishPhoto", forIndexPath: indexPath)
        
        let imageView = UIImageView(image: photos[indexPath.row])
        
        imageView.frame = CGRect(x: 0, y: 0.5, width: 54, height: 54)
    
        cell.addSubview(imageView)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == photos.count - 1 {
            let pickerController = DKImagePickerController()
            pickerController.defaultSelectedAssets = self.selecedPhotos
            pickerController.showsCancelButton = true
            pickerController.maxSelectableCount = 9
            
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                self.photos.removeAll()
                
                if assets.count != 0 {
                    for index in 0...assets.count-1 {
                        self.photos.append(
                            UtilBox.getAssetThumbnail(assets[index].originalAsset!))
                    }
                }
                
                self.photos.append(UIImage(named: "add_picture")!)
                
                self.selecedPhotos = assets
                
                self.photoCollectionView.reloadData()
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
            }
            
            self.presentViewController(pickerController, animated: true){}
        }
    }
    
    func onUpdateTaskResult(result: Int, info: String) {
        
    }
    
    func onDeleteTaskResult(result: Int, info: String) {
        
    }
}

protocol TaskPublishDelegate {
    func didPublishTask(task: Task, photos: [UIImage])
}