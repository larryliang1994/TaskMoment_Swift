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
                if let responseString = response {
                    let json = JSON(UtilBox.convertStringToDictionary(responseString)!)
                    
                    if result {
                        let status = json["status"].intValue
                        if status == Constants.Success {
                            self.handleCookie(json["memberCookie"].stringValue)
                            self.loginDelegate.onLoginResult(true, info: json["info"].stringValue)
                        } else {
                            self.loginDelegate.onLoginResult(false, info: json["info"].stringValue)
                        }
                    }
                } else {
                    self.loginDelegate.onLoginResult(false, info: "登录失败")
                }
        }
    }
    
    func handleCookie(cookie: String) {
        
    }
}

protocol LoginDelegate {
    func onLoginResult(result: Bool, info: String)
}
