//
//  AlamofireUtil.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SWXMLHash
import Alamofire
import SwiftyJSON

class AlamofireUtil: PrDelegate {
    var telephoneNum: String?
    var verifyCode: String?
    var requestDelegate: RequestDelegate?
    
    func requestWithSoap(soapKey: [String], soapValue: [String], params: [String: String],
        requestDelegate: RequestDelegate?) {
        self.telephoneNum = params["telephoneNum"]
        self.verifyCode = params["verifyCode"]
        self.requestDelegate = requestDelegate
        
        let connector = PrSoapConnector(delegate: self)
        connector.process("soap_server", getWServiceParamaters: soapKey, getWServiceParamatersValues: soapValue, getWServiceURL: Constants.soapTarget)
    }
    
    func onPreExecute(){}
    
    func onPostExecute(response: String){
        let xml = SWXMLHash.parse(response)
        
        let soapUrl = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:soap_serverResponse"]["return"].element?.text
        
        var parameters: [String: String]
        if verifyCode != nil {
            parameters = ["mobile": telephoneNum!, "check_code": verifyCode!]
        } else {
            parameters = ["mobile": telephoneNum!]
        }
        
        telephoneNum = nil
        verifyCode = nil
        
        Alamofire.request(.POST, Constants.serverUrl + "/act/ajax.php?a=" + soapUrl!,
            parameters: parameters)
            .responseString{ response in
                
                let result = response.result.value

                let json = JSON(self.convertStringToDictionary(result!)!)
                
                if response.result.isSuccess {
                    let status = json["status"].intValue
                    if status == Constants.Success {
                        self.requestDelegate?.onResponse(status, info: String(json["info"]))
                    } else {
                        self.requestDelegate?.onResponse(Constants.Failed, info: String(json["info"]))
                    }
                } else {
                    self.requestDelegate?.onResponse(Constants.Failed, info: String(json["info"]))
                }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

protocol RequestDelegate {
    func onResponse(resultCode: Int, info: String)
}