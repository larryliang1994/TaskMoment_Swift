//
//  Urls.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/15.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation

class Urls {
    static let SoapTarget = "http://soap.adm.jiubaiwang.cn" + "/index.php?jbbh=20043&soap_server=1"
    static let ServerUrl = "http://20045.jiubai.cc"
    
    static let MediaCenter = "http://taskmoment.image.alimmdn.com/"
    static let BackgroundMediaCenter = MediaCenter + "background/"
    static let ProtraitMediaCenter = MediaCenter + "portrait/"
    static let TaskMediaCenter = MediaCenter + "task/"
    
    static let MyCompany = "my_company"
    static let JoinedCompany = "my_join_company"
    static let CreateCompany = "create_company"
    static let GetTaskList = "get_renwulist"
    static let GetMember = "get_chengyuan&t_active_cid=";
    static let PublishTask = "renwu_add"
    static let UpdateTaskPicture = "renwu_update"
    static let GetUserInfo = "get_user_info"
    static let DeleteMember = "delChengyuan"
    static let AddMember = "chengyuan_add"
    static let UpdateUserInfo = "update_user_info"
}