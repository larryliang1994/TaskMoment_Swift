//
//  UploadImageModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation


class UploadImageModel: UploadImageProtocol {
    var uploadNum = 0
    var pictureList = [String]()
    
    var uploadImageDelegate: UploadImageDelegate?
    
    init(uploadImageDelegate: UploadImageDelegate) {
        self.uploadImageDelegate = uploadImageDelegate
    }
    
    func doUploadImage(imageData: NSData, dir: String, fileName: String) {
        let notification = TFEUploadNotification(
            progress: { (uploadSession, percentage) -> Void in
                print(percentage)
            },
            success: { (uploadSession, url) -> Void in
                print("success")
                self.uploadImageDelegate?.onUploadImageResult(Constants.Success, info: "")
            },
            failed: { (uploadSession, error) -> Void in
                print("failed")
                self.uploadImageDelegate?.onUploadImageResult(Constants.Failed, info: "图片上传失败，请重试")
        })
        
        MediaServiceUtil.uploadImage(
            imageData,
            fileName: fileName,
            dir: dir,
            notification: notification)
    }
    
    func doUploadImages(images: [UIImage], dir: String) {
        uploadNum = 0
        pictureList.removeAll()
        
        uploadImages(images, dir: dir)
    }
    
    private func uploadImages(images: [UIImage], dir: String) {
        let notification = TFEUploadNotification(
            progress: { (uploadSession, percentage) -> Void in
            },
            success: { (uploadSession, url) -> Void in
                // 已上传图片数加1
                self.uploadNum++
                
                // 记录已上传的图片的文件名
                self.pictureList.append(url)
                
                print(url)
                
                if self.uploadNum < images.count {
                    // 接着上传下一张图片
                    self.uploadImages(images, dir: dir)
                } else {
                    self.uploadImageDelegate?.onUploadImagesResult(Constants.Success, info: "", pictureList: self.pictureList)
                }
            },
            failed: { (uploadSession, error) -> Void in
                self.uploadImageDelegate?.onUploadImagesResult(Constants.Failed, info: "图片上传失败，请重试", pictureList: self.pictureList)
        })
        
        MediaServiceUtil.uploadImage(
            UtilBox.compressImage(images[uploadNum], maxSize: Constants.ImageSize.Task),
            fileName: UtilBox.MD5(String(NSDate().timeIntervalSince1970)) + ".jpg",
            dir: dir,
            notification: notification)
    }
}

protocol UploadImageDelegate {
    func onUploadImageResult(result: Int, info: String)
    func onUploadImagesResult(result: Int, info: String, pictureList: [String])
}