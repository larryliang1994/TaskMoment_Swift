//
//  TaskProtocol.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

protocol TaskProtocol {
    func doPublishTask(grade: String, desc: String, executor: String, supervisor: String, auditor: String, deadline: String, startTime: String)
    func doUpdateTask(taskID: String, pictureList: [String])
    func doDeleteTask(taskID: String)
}