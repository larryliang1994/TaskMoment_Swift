//
//  UploadImageProtocol.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

protocol UploadImageProtocol {
    func doUploadImage(imageData: NSData, dir: String, fileName: String)
    
    func doUploadImages(images: [UIImage], dir: String)
}