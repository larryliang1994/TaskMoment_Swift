//
//  MemberModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class MemberModel: MemberProtocol {
    static var memberList = [Member]()
    
    var memberDelegate: MemberDelegate?
    
    init(memberDelegate: MemberDelegate) {
        self.memberDelegate = memberDelegate
    }
    
    func doGetMember() {
        MemberModel.memberList = [Member]()
        MemberModel.memberList.removeAll()
        
        AlamofireUtil.requestWithCookie(Urls.GetMember + String(Config.CID!), parameters: nil) { (result, response) -> Void in
            if result {
                self.decodeMemberList(response)
            } else {
                self.memberDelegate?.onGetMemberResult(Constants.Failed, info: "请求失败")
            }
        }
    }
    
    func decodeMemberList(response: String) {
        let json = JSON(UtilBox.convertStringToDictionary(response)!)
        
        if json["status"].intValue != Constants.Success {
            self.memberDelegate?.onGetMemberResult(json["status"].intValue, info: json["info"].stringValue)
            
            return
        }
        
        let infoJson = json["info"]
        
        if infoJson != nil && infoJson.stringValue != "null" {
            for index in 0 ... infoJson.count-1 {
                let memberJson = infoJson[index]
                
                let member = Member(
                    name: memberJson["real_name"].stringValue,
                    mobile: memberJson["mobile"].stringValue,
                    id: memberJson["id"].stringValue,
                    mid: memberJson["mid"].stringValue)
                
                if member.name == "" {
                    member.name = String(member.mobile!)
                }
                
                MemberModel.memberList.append(member)
            }
        }
        
        self.memberDelegate?.onGetMemberResult(Constants.Success, info: "")
    }
    
    static func getMemberWithID(mid: Int) -> Member? {
        if memberList.count == 0 {
            return Member()
        }
        
        for index in 0 ... memberList.count - 1 {
            if Int(memberList[index].mid!) == mid {
                return memberList[index]
            }
        }
        
        return Member()
    }
}

protocol MemberDelegate {
    func onGetMemberResult(result: Int, info: String)
}