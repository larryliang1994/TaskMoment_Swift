//
//  CompanyModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/15.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class CompanyModel: CompanyProtocol {
    var companyDelegate: CompanyDelegate
    var companyList = [[Company]]()
    var myCompanyResponse: String?
    var joinedCompanyResponse: String?
    
    init(companyDelegate: CompanyDelegate) {
        self.companyDelegate = companyDelegate
    }
    
    func getCompany() {
        AlamofireUtil.requestWithCookie(Urls.MyCompany, parameters: nil)
            { (result, response) -> Void in
                
                if result {
                    self.myCompanyResponse = response
                    
                    AlamofireUtil.requestWithCookie(Urls.JoinedCompany, parameters: nil)
                        { (result, response) -> Void in
                            
                            if result {
                                self.joinedCompanyResponse = response
                                
                                self.builtCompanyList()
                            } else {
                                self.companyDelegate.onGetCompanyResult(Constants.Failed, info: "获取公司列表失败，请重试", companyList: nil)
                            }
                    }
                } else {
                    self.companyDelegate.onGetCompanyResult(Constants.Failed, info: "获取公司列表失败，请重试", companyList: nil)
                }
        }
    }
    
    func builtCompanyList() {
        companyList.removeAll()
        
        let myCompanyJson = JSON(UtilBox.convertStringToDictionary(myCompanyResponse!)!)
        let myCompanyStatus = myCompanyJson["status"].intValue
        
        if myCompanyStatus == Constants.Success {
            let jsonArray = myCompanyJson["info"]
            
            var companyArray = [Company]()
            for (index,subJson):(String, JSON) in jsonArray {
                companyArray.insert(
                    Company(
                        name: subJson["name"].stringValue,
                        cid: subJson["cid"].stringValue,
                        creator: subJson["mid"].stringValue), atIndex: Int(index)!)
            }
            
            companyList.insert(companyArray, atIndex: 0)
        } else {
            self.companyDelegate.onGetCompanyResult(myCompanyStatus, info: myCompanyJson["info"].stringValue, companyList: nil)
            
            return
        }
        
        let joinedCompanyJson = JSON(UtilBox.convertStringToDictionary(joinedCompanyResponse!)!)
        let joinedCompanyStatus = joinedCompanyJson["status"].intValue
        
        if joinedCompanyStatus == Constants.Success {
            let jsonArray = joinedCompanyJson["info"]
            
            var companyArray = [Company]()
            for (index,subJson):(String, JSON) in jsonArray {
                companyArray.insert(
                    Company(
                        name: subJson["name"].stringValue,
                        cid: subJson["cid"].stringValue,
                        creator: subJson["mid"].stringValue), atIndex: Int(index)!)
            }
            
            companyList.insert(companyArray, atIndex: 1)
        } else {
            self.companyDelegate.onGetCompanyResult(joinedCompanyStatus, info: joinedCompanyJson["info"].stringValue, companyList: nil)
            
            return
        }
        
        self.companyDelegate.onGetCompanyResult(Constants.Success, info: "", companyList: companyList)
    }
    
    func doCreateCompany(name: String) {
        AlamofireUtil.requestWithCookie(Urls.CreateCompany, parameters: ["name": name]) { (result, response) -> Void in
            let json = JSON(UtilBox.convertStringToDictionary(response)!)
            
            self.companyDelegate.onCreateCompanyResult(json["status"].intValue, info: json["info"].stringValue)
        }
    }
}

protocol CompanyDelegate {
    func onGetCompanyResult(result: Int, info: String, companyList: [[Company]]?)
    func onCreateCompanyResult(result: Int, info: String)
}