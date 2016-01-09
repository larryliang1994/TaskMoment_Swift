//
//  MediaServiceUtil.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/8.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class MediaServiceUtil {
    static func initMediaService(callback: (result: Bool) -> Void) {
        TaeSDK.sharedInstance().asyncInit(
            { () -> Void in
                callback(result: true)
            })
            { (error: NSError!) -> Void in
                callback(result: false)
            }
    }
    
    static func uploadImage(imageData: NSData) {
        
        let progress = TFEUploadProgress(TFEUploadSession(), NSUInteger(1))
        let notification = TFEUploadNotification(progress, success: )
        ALBBMedia.sharedInstance().uploadByData(imageData, notification: TFEUploadNotification!)
    }
    
    
}