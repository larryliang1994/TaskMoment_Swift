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

class AlamofireUtil {
    static func requestWithSoap(soapKey: [String], soapValue: [String], params: [String: String],
        callback : (result: Bool, response: String?) -> Void) {
            
            getUrlBySoap(soapKey, soapValue: soapValue) { (response) -> Void in
                Alamofire.request(.POST, Constants.ServerUrl + "/act/ajax.php?a=" + response + "&is_app=1", parameters: params)
                    .responseString{ response in
                        if response.result.isSuccess {
                            callback(result: true, response: response.result.value)
                        } else {
                            callback(result: false, response: "")
                        }
                }
            }
    }
    
    static func requestWithCookie(url: String, parameters: [String: String]?,
        callback : (result: Bool, response: String) -> Void) {

            Alamofire.request(.POST, Constants.ServerUrl + "/ajax.php?a=" + url,
                headers: ["Cookie": "memberCookie=\(Config.Cookie!)"], parameters: parameters)
                .responseString{ response in
                    if response.result.isSuccess {
                        callback(result: true, response: response.result.value!)
                    } else {
                        callback(result: false, response: "")
                    }
            }
    }
    
    static func getUrlBySoap(soapKey: [String], soapValue: [String], callback: (response: String)-> Void) {
        let connect = PrSoapConnector() { (response) -> Void in
            
            let xml = SWXMLHash.parse(response)
            
            let soapUrl = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:soap_serverResponse"]["return"].element?.text
            
            callback(response: soapUrl!)
        }
        
        connect.process("soap_server", getWServiceParamaters: soapKey, getWServiceParamatersValues: soapValue, getWServiceURL: Constants.SoapTarget)
    }
}