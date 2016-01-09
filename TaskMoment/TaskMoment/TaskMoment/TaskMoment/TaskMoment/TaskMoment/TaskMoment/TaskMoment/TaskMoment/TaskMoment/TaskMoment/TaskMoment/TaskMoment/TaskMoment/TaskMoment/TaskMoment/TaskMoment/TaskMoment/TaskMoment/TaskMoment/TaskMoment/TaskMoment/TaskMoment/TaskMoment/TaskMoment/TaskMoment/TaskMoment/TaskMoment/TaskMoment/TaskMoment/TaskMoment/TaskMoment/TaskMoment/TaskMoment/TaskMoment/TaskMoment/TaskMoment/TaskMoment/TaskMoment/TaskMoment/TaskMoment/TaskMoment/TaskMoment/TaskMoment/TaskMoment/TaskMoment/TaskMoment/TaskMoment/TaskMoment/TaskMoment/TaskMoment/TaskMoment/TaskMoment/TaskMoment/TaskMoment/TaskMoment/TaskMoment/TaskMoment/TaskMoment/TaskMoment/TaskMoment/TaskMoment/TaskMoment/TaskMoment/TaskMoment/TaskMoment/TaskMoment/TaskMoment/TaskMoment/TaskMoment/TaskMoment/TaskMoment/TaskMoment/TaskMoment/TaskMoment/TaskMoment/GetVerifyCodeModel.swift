//
//  getVerifyCodeModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetVerifyCodeModel : GetVerifyCodeProtocol{
    var getVerifyCodeDelegate: GetVerifyCodeDelegate
    
    init(getVerifyCodeDelegate: GetVerifyCodeDelegate) {
        self.getVerifyCodeDelegate = getVerifyCodeDelegate
    }
    
    func doGetVerifyCode(telephoneNum: String) {
        let soapKey = ["param", "type","table_name", "feedback_url", "return"]
        let soapValue = ["ajax", "sms_send_verifycode", Config.Random!, "", "1"]
        
        AlamofireUtil.requestWithSoap(soapKey, soapValue: soapValue, params: ["mobile": telephoneNum],
            callback: { (result, response) -> Void in
                if let responseString = response {
                    let json = JSON(UtilBox.convertStringToDictionary(responseString)!)
                    
                    if result {
                        let status = json["status"].intValue
                        if status == Constants.Success {
                            self.getVerifyCodeDelegate.onGetVerifyCodeResult(true, info: json["info"].stringValue)
                        } else {
                            self.getVerifyCodeDelegate.onGetVerifyCodeResult(false, info: json["info"].stringValue)
                        }
                    }
                } else {
                    self.getVerifyCodeDelegate.onGetVerifyCodeResult(false, info: "短信发送失败")
                }
        })
    }
}

protocol GetVerifyCodeDelegate {
    func onGetVerifyCodeResult(result: Bool, info: String)
}