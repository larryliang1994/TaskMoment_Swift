//
//  AppDelegate.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        initService()
        
        return true
    }
    
    func initService() {
        // 初始化网络状态
        getNetworkState()
        
        // 读取存储好的数据——cookie，公司信息，个人信息
        loadStorageData()
        
        // 初始化数据统计服务
        MobClick.startWithAppkey(Constants.Key.UMAppKey, reportPolicy: BATCH,
            channelId: "developer")
        
        // 初始化Bug统计
        initBugly()
    }
    
    func loadStorageData() {
        Config.Random = String(arc4random_uniform(100000))
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        Config.Cookie = userDefaults.stringForKey(Constants.UserDefaultKey.Cookie)
        Config.Nickname = userDefaults.stringForKey(Constants.UserDefaultKey.Nickname)
        Config.Mid = userDefaults.stringForKey(Constants.UserDefaultKey.Mid)
        Config.CID = userDefaults.stringForKey(Constants.UserDefaultKey.Cid)
        Config.CompanyName = userDefaults.stringForKey(Constants.UserDefaultKey.CompanyName)
        Config.CompanyBackground = userDefaults.stringForKey(Constants.UserDefaultKey.CompanyBackground)
        Config.CompanyCreator = userDefaults.stringForKey(Constants.UserDefaultKey.CompanyCreator)
        Config.Portrait = userDefaults.stringForKey(Constants.UserDefaultKey.Portrait)
        Config.Time = userDefaults.stringForKey(Constants.UserDefaultKey.Time)
        
        if Config.Time == nil || Config.Time == "" {
            Config.Time = String(Int(NSDate().timeIntervalSince1970))
            userDefaults.setValue(Config.Time, forKey: Constants.UserDefaultKey.Time)
        }
        
        if Config.Nickname == "" || Config.Nickname == "null" {
            Config.Nickname = "我"
        }
    }
    
    func getNetworkState() {
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
        
            // 判断连接状态
            if reachability.isReachable(){
                Config.IsReachable = true
            }else{
                Config.IsReachable = false
            }
            
            reachability.whenReachable = { reachability in
                Config.IsReachable = true
                
                print(true)
            }
            
            reachability.whenUnreachable = { reachability in
                Config.IsReachable = false
                
                print(false)
            }
            
            try reachability.startNotifier()
        } catch {
            
        }
    }
    
    func initBugly() {
        CrashReporter.sharedInstance().enableLog(true)
        CrashReporter.sharedInstance().installWithAppId(Constants.Key.BuglyAppID)
        //NSObject.performSelector("crash", withObject: nil, afterDelay: 3.0)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

