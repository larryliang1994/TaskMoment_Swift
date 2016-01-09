//
//  TimelineTableViewCell.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import Haneke

class TimelineTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, MemberDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet var executorLabel: UILabel!
    @IBOutlet var supervisorLabel: UILabel!
    @IBOutlet var auditorLabel: UILabel!
    
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var publishTimeLabel: UILabel!
    
    @IBOutlet var picturesCollectionView: UICollectionView!
    @IBOutlet var picturesHeight: NSLayoutConstraint!
    
    @IBOutlet var commentTableView: UITableView!
    
    let spacing:CGFloat = 6
    var itemWidth: CGFloat? {
        didSet {
            let row = task?.pictures == nil ? 0 : (task?.pictures?.count)!
            picturesHeight.constant = itemWidth! * CGFloat(row / 3 + 1) + spacing * CGFloat(row / 3)
        }
    }
    
    var task: Task? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nicknameLabel.text = task?.nickname
        descLabel.text = task?.desc
        
        if MemberModel.memberList.count == 0 {
            MemberModel(memberDelegate: self).doGetMember()
        } else {
            initESA()
        }
        
        deadlineLabel.text = "完成期限：" + UtilBox.getDateFromString((task?.deadline)!, format: Constants.DateFormat.MDHm)
        startTimeLabel.text = "开始时间：" + UtilBox.getDateFromString((task?.startTime)!, format: Constants.DateFormat.MDHm)
        publishTimeLabel.text = "发布时间：" + UtilBox.getDateFromString((task?.createTime)!, format: Constants.DateFormat.MDHm)
        
        portraitImageView.hnk_setImageFromURL(NSURL(
            string: Urls.ProtraitMediaCenter + String((task?.mid)!) + ".jpg")!)
        UtilBox.setShadow(portraitImageView, opacity: 0.2)
        
        picturesCollectionView.dataSource = self
        picturesCollectionView.delegate = self
    
        self.picturesCollectionView?.backgroundColor = UIColor.whiteColor()
        let layout:UICollectionViewFlowLayout = self.picturesCollectionView.collectionViewLayout
            as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
    }
    
    func initESA() {
        executorLabel.text = "执行者：" + (MemberModel.getMemberWithID((task?.executor)!)?.name!)!
        supervisorLabel.text = "监督者：" + (MemberModel.getMemberWithID((task?.supervisor)!)?.name!)!
        auditorLabel.text = "审核者：" + (MemberModel.getMemberWithID((task?.auditor)!)?.name!)!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return task?.pictures == nil ? 0 : (task?.pictures!.count)!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:TimelinePicturesCollectionViewCell  = collectionView.dequeueReusableCellWithReuseIdentifier("timelinePictureCell", forIndexPath: indexPath) as! TimelinePicturesCollectionViewCell
        
        if task?.pictures != nil {
            cell.pictureUrl = task?.pictures![indexPath.row]
        }
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.pictureImageView.contentMode = .ScaleAspectFill
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        itemWidth = (self.picturesCollectionView!.bounds.width - spacing * CGFloat(3-1)) / CGFloat(3)
        
        return CGSizeMake(itemWidth!, itemWidth!)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        cell.comment = task?.comments![indexPath.row]
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (task?.comments?.count)!
    }
    
    func onGetMemberResult(result: Int, info: String) {
        if result == Constants.Success {
            initESA()
        } else {
            print(info)
        }
    }
}