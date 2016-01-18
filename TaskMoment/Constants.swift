//
//  Constants.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Constants {
    struct ControllerID {
        static let Login = "loginViewController"
        static let Company = "companyViewController"
        static let Main = "mainViewController"
    }
    
    struct UserDefaultKey {
        static let Cookie = "cookie"
        static let Nickname = "nickname"
        static let Portrait = "portrait"
        static let Mid = "mid"
        static let Cid = "cid"
        static let CompanyName = "companyName"
        static let CompanyCreator = "companyCreator"
        static let CompanyBackground = "companyBackground"
        static let Time = "time"
    }
    
    struct SegueID {
        static let Login = "loginSegue"
        static let ChooseCompany = "chooseCompanySegue"
        static let Logout = "logoutSegue"
        static let GoToLogin = "goToLoginSegue"
        static let GoToMain = "goToMainSegue"
        static let PublishTask = "pubilshTaskSegue"
        static let SwitchCompany = "switchCompanySegue"
        static let About = "aboutSegue"
    }
    
    struct DateFormat {
        static let MDHm = "MM/dd HH:mm"
        static let Full = "YYYY/MM/dd HH:mm"
    }
    
    struct Key {
        static let UMAppKey = "568f14d967e58e36720029f2"
        static let BuglyAppKey = "sum9PMxLoo8YKqy1"
        static let BuglyAppID = "900017214"
    }
    
    struct Dir {
        static let Portrait = "/portrait"
        static let Background = "/background"
        static let Task = "/task"
    }
    
    struct ImageSize {
        static let Background = 500 * 1024
        static let Task = 300 * 1024
        static let Portrait = 100 * 1024
    }
    
    static let Success = 900001
    static let Failed = 0
    static let NoMore = 900900
    
    static let LoadNum = 8
    
    static let NameSpace = "TaskMoment"
    
    static let ShareText = "任务圈"
    static let ShareUrl = "http://adm.jiubaiwang.cn/WebSite/20055/uploadfile/webeditor2"
}