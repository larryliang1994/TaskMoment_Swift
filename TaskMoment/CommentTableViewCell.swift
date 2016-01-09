//
//  CommentTableViewCell.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var contentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            contentLabel.text = comment?.content
        }
    }
}
