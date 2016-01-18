//
//  AddMemberViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 16/1/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddMemberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var telephoneNumTextField: UITextField!
    @IBOutlet var errorInfoLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var okBarButton: UIBarButtonItem!
    
    var addMemberDelegate: AddMemberDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
        
        initView()
    }
    
    // 初始化其它view
    func initView() {
        telephoneNumTextField.delegate = self
        
        errorInfoLabel.text = ""
    }
    
    // 初始化NavigationBar
    func initNavBar() {
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor(red: 0x26/255, green: 0x32/255, blue: 0x38/255, alpha: 1.0)
        self.navigationItem.title = "添加成员"
        
        let backBtn = UIBarButtonItem()
        backBtn.title = "返回"
        self.navigationItem.backBarButtonItem = backBtn
        navBar.tintColor = UIColor.whiteColor()
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = true
    }

    @IBAction func addMember(sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        okBarButton.enabled = false
        let params = ["mobile": telephoneNumTextField.text!, "cid": Config.CID!]
        AlamofireUtil.requestWithCookie(Urls.AddMember, parameters: params)
            { (result, response) -> Void in
                if result {
                    let json = JSON(UtilBox.convertStringToDictionary(response)!)
                    
                    if json["status"].stringValue == String(Constants.Success) {
                        //self.errorInfoLabel.text = json["info"].stringValue
                        
                        let member = Member(name: json["real_name"].stringValue, mobile: json["mobile"].stringValue, id: json["id"].stringValue, mid: json["mid"].stringValue)
                        self.addMemberDelegate?.didAddMember(member)
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        self.errorInfoLabel.text = json["info"].stringValue
                    }
                    
                    self.activityIndicator.stopAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                    
                    UtilBox.alert(self, message: "添加失败，请重试")
                }
                
                self.okBarButton.enabled = true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if range.location >= 11 {
            return false
        }

        let telephoneNum = telephoneNumTextField.text?.characters.count == 10 ?
            telephoneNumTextField.text! + "1" : telephoneNumTextField.text!
            
        if range.location >= 10
            && textField.text?.characters.count >= 10
            && UtilBox.isTelephoneNum(telephoneNum){
            errorInfoLabel.text = ""
        } else {
            errorInfoLabel.text = "请填入11位手机号"
        }
        
        return true
    }
}

protocol AddMemberDelegate {
    func didAddMember(member: Member)
}
