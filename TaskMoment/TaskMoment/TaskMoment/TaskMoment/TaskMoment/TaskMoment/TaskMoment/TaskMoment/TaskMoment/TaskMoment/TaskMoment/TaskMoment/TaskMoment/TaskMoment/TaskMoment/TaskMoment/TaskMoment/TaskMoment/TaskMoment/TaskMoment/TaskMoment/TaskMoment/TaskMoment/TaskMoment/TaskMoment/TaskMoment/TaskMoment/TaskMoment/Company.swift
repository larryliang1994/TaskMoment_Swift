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
    var cid: String?
    var creator: String?
    
    init(name: String?){
        self.name = name
    }
    
    init(name: String, cid: String?, creator: String?) {
        self.name = name
        self.cid = cid
        self.creator = creator
    }
}