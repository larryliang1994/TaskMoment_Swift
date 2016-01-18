//
//  TimelineViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/28.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController, TimelineDelegate, TaskPublishDelegate, UploadImageDelegate, TaskDelegate {

    @IBOutlet var pictureCollectionView: UICollectionView!
    
    var rowHeight: CGFloat = 700
    
    var taskID: Int?
    
    private var taskList = [Task]() {
        didSet {
            tableView.reloadData()
            
            refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBavBar()
        
        initView()
        
        refresh()
    }
    
    // 初始化其它view
    func initView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // 初始化NavigationBar
    func initBavBar() {
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 0.5)
        navBar.translucent = true
        
        let backBtn = UIBarButtonItem()
        backBtn.title = "返回"
        self.navigationItem.backBarButtonItem = backBtn
        navBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.title = Config.CompanyName! + "的任务圈"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = false
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        
        TimelineModel(timelineDelegate: self).doPullTimeline(Int(NSDate().timeIntervalSince1970), type: "refresh")
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
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
            
//            rowHeight = tableView.estimatedRowHeight + CGFloat((cell.task?.pictures?.count)! / 8 * 99)
//            self.tableView(tableView, heightForRowAtIndexPath: indexPath)
//            
//            print(tableView.rowHeight)
//            print(tableView.estimatedRowHeight)
            
            return cell
        }
    }
    
    @IBAction func publishTask(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Constants.SegueID.PublishTask, sender: self)
    }
    
    // 跳转前设置代理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController
            destination = navCon.visibleViewController!
        }
        
        if let tpvc = destination as? TaskPublishViewController {
            tpvc.taskPublishDelegate = self
        }
    }
    
    func onPullTimelineResult(result: Int, info: String) {
        if result == Constants.Success || result == Constants.NoMore{
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                sleep(1)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.taskList = TimelineModel.taskList
                })
            }
        } else {
            UtilBox.alert(self, message: info)
            
            print(info)
            
            refreshControl?.endRefreshing()
        }
    }
    
    // 从TaskPublish页面跳转回来并且已经发布了任务
    func didPublishTask(task: Task, photos: [UIImage]) {
        if photos.count > 0 {
            // 开始上传图片
            UploadImageModel(uploadImageDelegate: self).doUploadImages(photos, dir: Constants.Dir.Task)
        }
        
        taskID = task.id
        
        TimelineModel.taskList.insert(task, atIndex: 0)
        
        tableView.reloadData()
    }
    
    func onUploadImageResult(result: Int, info: String) {
        print(result)
    }
    
    func onUploadImagesResult(result: Int, info: String, pictureList: [String]) {
        if result == Constants.Success {
            TaskModel(taskDelegate: self).doUpdateTask(String(taskID!), pictureList: pictureList)
        } else {
            for index in 0...TimelineModel.taskList.count - 1 {
                if taskID == TimelineModel.taskList[index].id {
                    TimelineModel.taskList[index].sendState = Task.SendState.Failed
                    tableView.reloadData()
                    break
                }
            }
            UtilBox.alert(self, message: info)
        }
    }
    
    func onPublishTaskResult(result: Int, info: String) {
    }
    
    func onUpdateTaskResult(result: Int, info: String) {
        if result == Constants.Success {
            for index in 0...TimelineModel.taskList.count - 1 {
                if taskID == TimelineModel.taskList[index].id {
                    TimelineModel.taskList[index].sendState = Task.SendState.Success
                    tableView.reloadData()
                    break
                }
            }
        } else {
            for index in 0...TimelineModel.taskList.count - 1 {
                if taskID == TimelineModel.taskList[index].id {
                    TimelineModel.taskList[index].sendState = Task.SendState.Failed
                    tableView.reloadData()
                    break
                }
            }
            UtilBox.alert(self, message: info)
        }
    }
    
    func onDeleteTaskResult(result: Int, info: String) {
        
    }
}
