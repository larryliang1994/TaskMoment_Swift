//
//  UserInfoViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/30.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import Haneke

class UserInfoViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadImageDelegate, UITextFieldDelegate, ChangeNicknameDelegate {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        
        initView()
        
        addTapGesture()
    }
    
    // 初始化其它view
    func initView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        portraitImageView.hnk_setImageFromURL(NSURL(
            string: Urls.ProtraitMediaCenter + Config.Mid! + ".jpg")!)
        //UtilBox.setShadow(portraitImageView, opacity: 0.2)
        
        nicknameLabel.text = Config.Nickname!
    }
    
    // 初始化NavigationBat
    func initNavBar() {
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        //navBar.translucent = true;
        
        self.navigationItem.title = "个人中心"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    // 添加点击事件
    func addTapGesture() {
        portraitImageView.userInteractionEnabled = true
        let portraitTap = UITapGestureRecognizer(target: self, action: "changePortrait")
        portraitImageView.addGestureRecognizer(portraitTap)
        
        nicknameLabel.userInteractionEnabled = true
        let nicknameTap = UITapGestureRecognizer(target: self, action: "changeNickname")
        nicknameLabel.addGestureRecognizer(nicknameTap)
    }
    
    // 查看/修改头像
    func changePortrait() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "更换头像",style: .Default)
            { (action: UIAlertAction) -> Void in
                let ipc = UIImagePickerController()
                ipc.delegate = self
                ipc.sourceType = .SavedPhotosAlbum
                ipc.allowsEditing = true
                ipc.navigationBar.barStyle = .Black
                
                self.presentViewController(ipc, animated: true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // 选好了图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        UploadImageModel(uploadImageDelegate: self).doUploadImage(
            UtilBox.compressImage(image, maxSize: Constants.ImageSize.Portrait),
            dir: Constants.Dir.Portrait, fileName: Config.Mid! + ".jpg")
    }
    
    // 上传后回调
    func onUploadImageResult(result: Int, info: String) {
        if result == Constants.Success {
            portraitImageView.hnk_setImageFromURL(NSURL(
                string: Urls.ProtraitMediaCenter + Config.Mid! + ".jpg")!)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    // 修改昵称
    func changeNickname() {
        let alert = UIAlertController(title: nil, message: "修改昵称", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "确定", style: .Default)
            { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first! as UITextField
                
                if textField.text != nil && textField.text != Config.Nickname {
                    ChangeNicknameMode(changeNicknameDelegate: self).doChangeNickname(textField.text!)
                }
            }
        )
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = Config.Nickname
            textField.placeholder = "昵称"
            textField.delegate = self
            textField.font = UIFont(name: "Helvetica", size: 17.0)
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func onChangeNicknameResult(result: Int, info: String) {
        if result == Constants.Success {
            nicknameLabel.text = info
            Config.Nickname = info
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location >= 12 {
            return false
        } else {
            return true
        }
    }
    
    // 行点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        cell.selected = false
    }
    
    func onUploadImagesResult(result: Int, info: String, pictureList: [String]) {
    }
}
