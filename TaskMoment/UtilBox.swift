//
//  UtilBox.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import UIKit

class UtilBox {
    // 验证是否为手机号
    static func isTelephoneNum(input: String) -> Bool {
        let regex:NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: "^[1][35789][0-9]{9}$", options: NSRegularExpressionOptions.CaseInsensitive)
            
            let  matches = regex.matchesInString(input, options: NSMatchingOptions.ReportCompletion , range: NSMakeRange(0, input.characters.count))
            
            if matches.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // 字符串转Dic
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
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
    
    // 设置图片阴影
    static func setShadow(imageView: UIImageView, opacity: Float) {
        imageView.layer.shadowOpacity = opacity
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    // 清除用户数据
    static func clearUserDefaults() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Cookie)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Nickname)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Portrait)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Mid)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Cid)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.CompanyName)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.CompanyCreator)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.CompanyBackground)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Time)
    }
    
    // 时间戳转字符串
    static func getDateFromString(date: String, format: String) -> String {
        let outputFormat = NSDateFormatter()
        // 格式化规则
        outputFormat.dateFormat = format
        // 定义时区
        outputFormat.locale = NSLocale(localeIdentifier: "shanghai")
        // 发布时间
        let pubTime = NSDate(timeIntervalSince1970: Double(date)!)
        return outputFormat.stringFromDate(pubTime)
    }
    
    // 字符串转时间戳
    static func stringToDate(date: String, format: String) -> NSTimeInterval {
        
        let outputFormatter = NSDateFormatter()
        
        outputFormatter.dateFormat = format
        
        return outputFormatter.dateFromString(date)!.timeIntervalSince1970
    }
}
