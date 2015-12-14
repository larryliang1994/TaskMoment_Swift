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
            
        let connect = PrSoapConnector() { (response) -> Void in
            
            let xml = SWXMLHash.parse(response)
            
            let soapUrl = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:soap_serverResponse"]["return"].element?.text
            
            Alamofire.request(.POST, Constants.serverUrl + "/act/ajax.php?a=" + soapUrl!, parameters: params)
                .responseString{ response in
                    callback(result: response.result.isSuccess, response: response.result.value)
            }
        }
        
        connect.process("soap_server", getWServiceParamaters: soapKey, getWServiceParamatersValues: soapValue, getWServiceURL: Constants.soapTarget)
    }
}