//
//  TimelineModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/29.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class TimelineModel: TimelineProtocol {
    static var taskList = [Task]()
    var timelineDelegate: TimelineDelegate?
    
    init(timelineDelegate: TimelineDelegate) {
        self.timelineDelegate = timelineDelegate
    }
    
    func doPullTimeline(requestTime:Int, type:String) {
        self.doPullTimeline(requestTime, type: type, mid: "", isAudit: "", isInvolved: "")
    }
    
    func doPullTimeline(requestTime:Int, type:String, mid:String, isAudit:String, isInvolved:String){
        
        if type == "refresh" {
            TimelineModel.taskList = [Task]()
            TimelineModel.taskList.removeAll()
        }
        
        let parameters = [
            "len": String(Constants.LoadNum),
            "cid": String(Config.CID!),
            "create_time": String(requestTime),
            "mid": mid,
            "shenhe": isAudit,
            "canyu": isInvolved]
        
        AlamofireUtil.requestWithCookie(Urls.GetTaskList, parameters: parameters) { (result, response) -> Void in
            if result {
                self.decodeTaskList(response)
            } else {
                self.timelineDelegate?.onPullTimelineResult(Constants.Failed, info: "请求失败")
            }
        }
    }
    
    func decodeTaskList(response: String) {
        let json = JSON(UtilBox.convertStringToDictionary(response)!)
        
        if json["status"].intValue != Constants.Success {
            self.timelineDelegate?.onPullTimelineResult(json["status"].intValue, info: json["info"].stringValue)
            
            return
        }
        
        let infoJson = json["info"]
        
        if infoJson != nil && infoJson.stringValue != "null" {
            
            for index in 0 ... infoJson.count-1 {
                let taskJson = infoJson[index]
                let task = Task(
                    id: taskJson["id"].intValue,
                    portraitUrl: Urls.ProtraitMediaCenter + taskJson["mid"].stringValue + ".jpg",
                    nickname: taskJson["show_name"].stringValue,
                    mid: taskJson["mid"].intValue,
                    grade: taskJson["p1"].stringValue,
                    desc: taskJson["comments"].stringValue,
                    executor: taskJson["ext1"].intValue,
                    supervisor: taskJson["ext2"].intValue,
                    auditor: taskJson["ext3"].intValue,
                    pictures: decodePictures(taskJson["works"]),
                    comments: docodeComment(taskJson["id"].intValue, commentsJson: taskJson["member_comment"]),
                    deadline: taskJson["time1"].stringValue,
                    startTime: taskJson["time2"].stringValue,
                    createTime: taskJson["create_time"].stringValue,
                    auditResult: taskJson["p2"].intValue,
                    sendState: Task.SendState.Success)
                TimelineModel.taskList.append(task)
            }
            
            timelineDelegate?.onPullTimelineResult(json["status"].intValue, info: "")
        } else {
            timelineDelegate?.onPullTimelineResult(Constants.Failed, info: "请求失败")
        }
    }
    
    func decodePictures(pictures: JSON) -> [String] {
        let pictureString = pictures.rawString()!
            .stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let picturesJson = JSON(pictureString.componentsSeparatedByString(","))
        
        var pictureList = [String]()
        if picturesJson != nil && picturesJson.stringValue != "null" && picturesJson.count != 0 {
            for index in 0 ... picturesJson.count - 1 {
                pictureList.append(picturesJson[index].stringValue)
            }
        }
        
        return pictureList
    }
    
    func docodeComment(taskID: Int, commentsJson: JSON) -> [Comment] {
        var commentList = [Comment]()
        
        if commentsJson != nil && commentsJson != "null" && commentsJson.count != 0 {
            for index in 0 ... commentsJson.count - 1 {
                
                let commentJson = commentsJson[index]
                
                var sender = commentJson["send_real_name"].stringValue
                sender = sender != "" ? sender : commentJson["send_mobile"].stringValue
                
                var receiver = commentJson["receiver_real_name"].stringValue
                receiver = receiver != "" ? receiver : commentJson["receiver_mobile"].stringValue
                
                if receiver == "" {
                    commentList.append(
                        Comment(taskID: taskID, sender: sender, senderID: commentJson["send_id"].intValue, content: commentJson["content"].stringValue, time: commentJson["create_time"].stringValue))
                } else {
                    commentList.append(
                        Comment(taskID: taskID, sender: sender, senderID: commentJson["send_id"].intValue, receiver: receiver, receiverID: commentJson["receiver_id"].intValue, content: commentJson["content"].stringValue, time: commentJson["create_time"].stringValue))
                }
            }
        }
        
        return commentList
    }
}

protocol TimelineDelegate{
    func onPullTimelineResult(result: Int, info: String)
}