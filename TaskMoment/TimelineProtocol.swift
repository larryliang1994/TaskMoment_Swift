//
//  TimelineProtocol.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/29.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

protocol TimelineProtocol {
    func doPullTimeline(requestTime:Int, type:String)
    func doPullTimeline(requestTime:Int, type:String, mid:String, isAudit:String, isInvolved:String)
}