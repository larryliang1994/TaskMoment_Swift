//
//  loginModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginModel : LoginProtocol{
    var loginDelegate : LoginDelegate
    
    init(loginDelegate : LoginDelegate) {
        self.loginDelegate = loginDelegate
    }
    
    func doLogin(telephoneNum: String, verifyCode: String) {
        let soapKey = ["param", "type","table_name", "feedback_url", "return"]
        let soapValue = ["ajax", "mobile_login", Config.Random!, "", "1"]
        
        AlamofireUtil.requestWithSoap(soapKey, soapValue: soapValue,
            params: ["mobile": telephoneNum, "check_code": verifyCode]) { (result, response) -> Void in
                if result {
                    let json = JSON(UtilBox.convertStringToDictionary(response!)!)
                    
                    let status = json["status"].intValue
                    if status == Constants.Success {
                        self.handleCookie(json["memberCookie"].stringValue)
                    } else {
                        self.loginDelegate.onLoginResult(false, info: json["info"].stringValue)
                    }
                    
                } else {
                    self.loginDelegate.onLoginResult(false, info: "登录失败")
                }
        }
    }
    
    func handleCookie(cookie: String) {
        let decodeKey = ["param", "string", "operation"]
        let decodeValue = ["authcode", cookie, "DECODE"]
        
        AlamofireUtil.getUrlBySoap(decodeKey, soapValue: decodeValue) { (response) -> Void in
            Config.Cookie = cookie
            
            let json = JSON(UtilBox.convertStringToDictionary(response)!)
            
            Config.Mid = json["id"].stringValue
            Config.Nickname = json["real_name"].stringValue
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            
            userDefault.setValue(Config.Cookie!, forKey: Constants.UserDefaultKey.Cookie)
            userDefault.setValue(Config.Mid!, forKey: Constants.UserDefaultKey.Mid)
            userDefault.setValue(Config.Nickname!, forKey: Constants.UserDefaultKey.Nickname)
            
            self.loginDelegate.onLoginResult(true, info: "登录成功")
        }
    }
}

protocol LoginDelegate {
    func onLoginResult(result: Bool, info: String)
}