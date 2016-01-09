//
//  TimelinePicturesCollectionViewCell.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/1.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class TimelinePicturesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var pictureUrl: String? {
        didSet {
            pictureImageView.hnk_setImageFromURL(NSURL(string: pictureUrl!)!)
        }
    }
}
