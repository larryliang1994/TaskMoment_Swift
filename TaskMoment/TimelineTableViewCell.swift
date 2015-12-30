//
//  TimelineTableViewCell.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import Haneke

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var task: Task? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nicknameLabel.text = task?.nickname
        descLabel.text = task?.desc
        portraitImageView.hnk_setImageFromURL(NSURL(
            string: Urls.ProtraitMediaCenter + String((task?.mid)!) + ".jpg")!)
        
        UtilBox.setShadow(portraitImageView, opacity: 0.2)
    }
    
}