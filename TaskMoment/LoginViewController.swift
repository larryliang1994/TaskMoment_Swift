//
//  ViewController.swift
//  Networking
//
//  Created by 梁浩 on 15/12/11.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, RequestDelegate {
    @IBOutlet weak var telephoneNumTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var getVerifyCodeButton: UIButton!
    
    var isGetVerifyCode = false
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Config.Random = String(arc4random_uniform(100000))
        
        loginButton.backgroundColor = UIColor.redColor()
        loginButton.layer.cornerRadius = 4
    }

    @IBAction func getVerifyCode(sender: UIButton) {
        
        if let telephoneNum = telephoneNumTextField.text {
            isGetVerifyCode = true
            
            let soapKey = ["param", "type","table_name", "feedback_url", "return"]
            let soapValue = ["ajax", "sms_send_verifycode", Config.Random!, "", "1"]
            
            AlamofireUtil().requestWithSoap(soapKey, soapValue: soapValue,
                params: ["telephoneNum": telephoneNum], requestDelegate: self)
        } else {
            print("empty")
        }
    }
    
    @IBAction func login(sender: UIButton) {
        if let telephoneNum = telephoneNumTextField.text {
            if let verifyCode = verifyCodeTextField.text {
                isLogin = true
                
                let soapKey = ["param", "type","table_name", "feedback_url", "return"]
                let soapValue = ["ajax", "mobile_login", Config.Random!, "", "1"]
                
                AlamofireUtil().requestWithSoap(soapKey, soapValue: soapValue,
                    params: ["telephoneNum": telephoneNum, "verifyCode": verifyCode], requestDelegate: self)
            } else {
                print("empty")
            }
        } else {
            print("empty")
        }
    }
    
    func onResponse(resultCode: Int, response: String) {
        if isGetVerifyCode {
            isGetVerifyCode = false
        } else if isLogin {
            let alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)

            
            isLogin = false
        }
    }
}

