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
                    executor: taskJson["executor"].intValue,
                    supervisor: taskJson["supervisor"].intValue,
                    auditor: taskJson["auditor"].intValue,
                    pictures: nil, comments: nil,
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
}

protocol TimelineDelegate{
    func onPullTimelineResult(result: Int, info: String)
}