//
//  TaskModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class TaskModel: TaskProtocol {
    var taskDelegate: TaskDelegate?
    
    init(taskDelegate: TaskDelegate) {
        self.taskDelegate = taskDelegate
    }
    
    func doPublishTask(grade: String, desc: String, executor: String, supervisor: String, auditor: String, deadline: String, startTime: String) {
        let params = ["p1": grade, "comments": desc, "ext1": executor, "ext2": supervisor, "ext3": auditor,
            "cid": Config.CID!, "time1": deadline, "time2": startTime]

        AlamofireUtil.requestWithCookie(Urls.PublishTask, parameters: params)
            { (result, response) -> Void in
                if result {
                    let json = JSON(UtilBox.convertStringToDictionary(response)!)
                    
                    let status = json["status"].intValue
                    if status == Constants.Success {
                        self.taskDelegate?.onPublishTaskResult(status, info: json["taskid"].stringValue)
                    } else {
                        self.taskDelegate?.onPublishTaskResult(status, info: json["info"].stringValue)
                    }
                } else {
                    self.taskDelegate?.onPublishTaskResult(Constants.Failed, info: "发布失败，请重试")
                }
        }
    }
    
    func doUpdateTask(taskID: String, pictureList: [String]) {
        let pictures = String(JSON(pictureList))
            .stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let params = ["taskid": taskID, "works": pictures]
        
        print(pictures)
        
        AlamofireUtil.requestWithCookie(Urls.UpdateTaskPicture, parameters: params)
            { (result, response) -> Void in
                if result {
                    let json = JSON(UtilBox.convertStringToDictionary(response)!)
                    
                    let status = json["status"].intValue
                    if status == Constants.Success {
                        // 注意这里可能需要清空图片列表
                        self.taskDelegate?.onUpdateTaskResult(Constants.Success, info: "")
                    } else {
                        self.taskDelegate?.onUpdateTaskResult(status, info: json["info"].stringValue)
                    }
                } else {
                    self.taskDelegate?.onUpdateTaskResult(Constants.Failed, info: "图片上传失败，请重试")
                }
        }
    }
    
    func doDeleteTask(taskID: String) {
    
    }
}

protocol TaskDelegate {
    func onPublishTaskResult(result: Int, info: String)
    func onUpdateTaskResult(result: Int, info: String)
    func onDeleteTaskResult(result: Int, info: String)
}