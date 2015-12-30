//
//  Comment.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/29.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Comment {
    var taskID: Int?
    var sender: String?
    var senderID: Int?
    var receiver: String?
    var receiverID: Int?
    var content: String?
    var time: String?
    
    init(){}
    
    init(taskID: Int, sender: String, senderID: Int, content: String, time: String){
        self.taskID = taskID
        self.sender = sender
        self.senderID = senderID
        self.content = content
        self.time = time
    }
    
    init(taskID: Int, sender: String, senderID: Int, receiver: String, receiverID: Int, content: String, time: String){
        self.taskID = taskID
        self.sender = sender
        self.senderID = senderID
        self.receiver = receiver
        self.receiverID = receiverID
        self.content = content
        self.time = time
    }
}