//
//  PrSoapConnector.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class PrSoapConnector: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate {
    var callback : (response: String) -> Void
    
    var mutableData:NSMutableData = NSMutableData()
    var currentElementName:NSString = ""
    var returnWServiceDataString = ""
    
    init(callback : (response: String) -> Void){
        //self.delegate = delegate
        self.callback = callback
    }
    
    func process(functionName: String, getWServiceParamaters: Array<String>, getWServiceParamatersValues: Array<String>, getWServiceURL: String){
        //delegate?.onPreExecute()
        var soapMessage = "<?xml version='1.0' encoding='utf-8'?>"
        soapMessage += "<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"
        soapMessage += "<soap:Body>"
        soapMessage += "<\(functionName) xmlns=\"http://tempuri.org/\">"
        for var i=0; i<getWServiceParamaters.count; i++
        {
            soapMessage += "<\(getWServiceParamaters[i])>\(getWServiceParamatersValues[i])</\(getWServiceParamaters[i])>"
        }
        soapMessage += "</\(functionName)>"
        soapMessage += "</soap:Body>"
        soapMessage += "</soap:Envelope>"
        
        let urlString = getWServiceURL
        let url: NSURL = NSURL(string: urlString)!
        let theRequest = NSMutableURLRequest(URL: url)
        let msgLength = String(soapMessage.characters.count)
        
        theRequest.HTTPMethod = "POST"
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        var mutableData : Void = NSMutableData.initialize()
        
        connection!.start()
        connection?.start()
        if let connection = connection{
            connection.start()
        } else {
            
        }
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!){
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        mutableData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!){
        let xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        returnWServiceDataString = NSString(data: mutableData, encoding: NSUTF8StringEncoding)! as String
        //delegate?.onPostExecute(returnWServiceDataString)
        
        callback(response: returnWServiceDataString)
    }
    
//    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!){
//        currentElementName = elementName
//    }
    
}