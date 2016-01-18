//
//  Member.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Member {
    var name: String?
    var mobile: String?
    var id: String?
    var mid: String?
    
    init(){
        self.name = ""
        self.mobile = ""
        self.id = ""
        self.mid = ""
    }
    
    init(name: String, mobile: String, id: String, mid: String) {
        self.name = name
        self.mobile = mobile
        self.id = id
        self.mid = mid
    }
}
