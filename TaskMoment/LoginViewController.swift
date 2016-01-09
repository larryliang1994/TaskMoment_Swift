//
//  ViewController.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/11.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, GetVerifyCodeDelegate, LoginDelegate {
    @IBOutlet weak var telephoneNumTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var getVerifyCodeButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor.lightGrayColor()
        loginButton.layer.cornerRadius = 4
        loginButton.enabled = false
        
        getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
        getVerifyCodeButton.layer.cornerRadius = 4
        getVerifyCodeButton.enabled = false
        
        telephoneNumTextField.delegate = self
        verifyCodeTextField.delegate = self
        
        let navBar = self.navigationController!.navigationBar
        
        navBar.barTintColor = UIColor.redColor()
        self.navigationItem.title = "任务圈"
        
        // 设置字体属性
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    // 获取验证码
    @IBAction func getVerifyCode(sender: UIButton) {
        
        activityIndicator.startAnimating()
            
        // 关闭键盘
        telephoneNumTextField.resignFirstResponder()
            
        GetVerifyCodeModel(getVerifyCodeDelegate: self).doGetVerifyCode(telephoneNumTextField.text!)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0, target: self, selector: "counting:",
                userInfo: nil, repeats: true)
        time = 60
        
        timer.tolerance = 0.1
        timer.fire()
    }
    
    // 倒计时
    var time = 60
    var isCounting = false
    func counting(timer: NSTimer) {
        _ = timer.userInfo
        
        if time != 0 {
            isCounting = true
            getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
            getVerifyCodeButton.enabled = false
            getVerifyCodeButton.setTitle("\(time)秒", forState: .Normal)
            time -= 1
        } else {
            isCounting = false
            getVerifyCodeButton.backgroundColor = UIColor.redColor()
            getVerifyCodeButton.enabled = true
            getVerifyCodeButton.setTitle("获取", forState: .Normal)
            timer.invalidate()
            
            textField(telephoneNumTextField, shouldChangeCharactersInRange: NSRange(location: 10, length: 1), replacementString: telephoneNumTextField.text!)
        }
    }
    
    // 登录
    @IBAction func login(sender: UIButton) {
        activityIndicator.startAnimating()
                
        // 关闭键盘
        verifyCodeTextField.resignFirstResponder()
        
        loginButton.enabled = false
                
        LoginModel(loginDelegate: self).doLogin(telephoneNumTextField.text!, verifyCode: verifyCodeTextField.text!)
    }
    
    // 获取验证码回调
    func onGetVerifyCodeResult(result: Bool, info: String) {
        activityIndicator.stopAnimating()

        let alertController = UIAlertController(title: "提示", message: info, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 登录回调
    func onLoginResult(result: Bool, info: String) {
        activityIndicator.stopAnimating()
        if result {     
            self.performSegueWithIdentifier(Constants.SegueID.Login, sender: self)
        } else {
            let alertController = UIAlertController(title: "提示", message: info, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // 控制编辑中的视图样式
    var loginButtonEnabled = false
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == telephoneNumTextField {
            if range.location >= 11 {
                return false
            }
            
            let telephoneNum = telephoneNumTextField.text?.characters.count == 10 ?
            telephoneNumTextField.text! + "1" : telephoneNumTextField.text!
            
            if range.location >= 10
                && textField.text?.characters.count >= 10
                && UtilBox.isTelephoneNum(telephoneNum){
                
                if !isCounting {
                    getVerifyCodeButton.backgroundColor = UIColor.redColor()
                    getVerifyCodeButton.enabled = true
                }
                    
                if loginButtonEnabled {
                    loginButton.backgroundColor = UIColor.redColor()
                    loginButton.enabled = true
                }
            } else {
                getVerifyCodeButton.enabled = false
                loginButton.enabled = false
                //loginButtonEnabled = false
                getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
        if textField == verifyCodeTextField {
            if range.location >= 6 {
                return false
            }
            
            if range.location >= 5 && textField.text?.characters.count == 5 {
                loginButton.enabled = true
                loginButtonEnabled = true
                loginButton.backgroundColor = UIColor.redColor()
            } else {
                loginButton.enabled = false
                loginButtonEnabled = false
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
        return true
    }
}

