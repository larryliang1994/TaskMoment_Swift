//
//  Company.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/13.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation

class Company {
    var name: String?
    var cid: Int?
    var creator: Int?
    
    init(name: String?){
        self.name = name
    }
    
    init(name: String, cid: Int?, creator: Int?) {
        self.name = name
        self.cid = cid
        self.creator = creator
    }
}