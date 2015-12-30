//
//  Member.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Member {
    var name: String?
    var mobile: Int?
    var id: Int?
    var mid: Int?
    
    init(){}
    
    init(name: String, mobile: Int, id: Int, mid: Int) {
        self.name = name
        self.mobile = mobile
        self.id = id
        self.mid = mid
    }
}
