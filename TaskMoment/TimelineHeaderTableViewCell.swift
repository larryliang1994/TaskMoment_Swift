//
//  TimelineHeaderTableViewCell.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class TimelineHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    func initHeader() {
        nicknameLabel.text = Config.Nickname
        
        backgroundImageView.hnk_setImageFromURL(NSURL(
            string: Urls.BackgroundMediaCenter + String((Config.CID)!) + ".jpg")!)
        portraitImageView.hnk_setImageFromURL(NSURL(
            string: Urls.ProtraitMediaCenter + Config.Mid! + ".jpg")!)
        
        UtilBox.setShadow(portraitImageView, opacity: 0.2)
        
//        //富文本设置
//        var attributeString = NSMutableAttributedString(string:"welcome to hangge.com")
//        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
//        attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
//            range: NSMakeRange(0,6))
//        //设置字体颜色
//        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(),
//            range: NSMakeRange(0, 3))
//        //设置文字背景颜色
//        attributeString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.greenColor(),
//            range: NSMakeRange(3,3))
//        label.attributedText = attributeString
    }
}