//
//  ChangeNicknameModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChangeNicknameMode: ChangeNicknameProtocol {
    
    var changeNicknameDelegate: ChangeNicknameDelegate?
    
    init(changeNicknameDelegate: ChangeNicknameDelegate) {
        self.changeNicknameDelegate = changeNicknameDelegate
    }
    
    func doChangeNickname(newNickname: String) {
        let params = ["real_name": newNickname]
        
        AlamofireUtil.requestWithCookie(Urls.UpdateUserInfo, parameters: params)
            { (result, response) -> Void in
                
                if result {
                    let json = JSON(UtilBox.convertStringToDictionary(response)!)
                    
                    if json["status"].intValue == Constants.Success {
                        self.changeNicknameDelegate?.onChangeNicknameResult(Constants.Success, info: newNickname)
                    } else {
                        self.changeNicknameDelegate?.onChangeNicknameResult(json["status"].intValue, info: json["info"].stringValue)
                    }
                } else {
                    self.changeNicknameDelegate?.onChangeNicknameResult(Constants.Failed, info: "修改昵称失败，请重试")
                }
        }
    }
}

protocol ChangeNicknameDelegate {
    func onChangeNicknameResult(result: Int, info: String)
}