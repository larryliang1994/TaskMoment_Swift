//
//  Task.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/29.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Task {
    var id: Int?
    var portraitUrl: String?
    var nickname: String?
    var mid: Int?
    var grade: String?
    var desc: String?
    var executor: Int?
    var supervisor: Int?
    var auditor: Int?
    var pictures: [String]?
    var comments: [Comment]?
    var deadline: String?
    var startTime: String?
    var createTime: String?
    var auditResult: Int?
    var sendState: Int?
    
    struct SendState {
        static let Sending = 0
        static let Success = 1
        static let Failed  = -1
    }
    
    init(){}
    
    init(id: Int, portraitUrl: String, nickname: String, mid: Int, grade: String, desc: String, executor: Int, supervisor: Int, auditor: Int, pictures: [String]?, comments: [Comment]?, deadline: String, startTime: String, createTime: String, auditResult: Int, sendState: Int){
        self.id = id
        self.portraitUrl = portraitUrl
        self.nickname = nickname
        self.mid = mid
        self.grade = grade
        self.desc = desc
        self.executor = executor
        self.supervisor = supervisor
        self.auditor = auditor
        self.pictures = pictures
        self.comments = comments
        self.deadline = deadline
        self.startTime = startTime
        self.createTime = createTime
        self.auditResult = auditResult
        self.sendState = sendState
    }
}