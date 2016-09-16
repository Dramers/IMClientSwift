//
//  LoginService.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public class LoginService: NSObject {
    public var loginServerAddress = "http://127.0.0.1:3002/"
    
    public static let shareInstance = LoginService()
    
    public static var isLogin: Bool {
        return LoginService.shareInstance.loginInfo != nil
    }
    public var loginInfo: LoginInfo?
    
    public func login(username: String, password: String, complete: (LoginInfo?, NSError?) -> Void) {
        
        Request.sendJsonRequest("\(loginServerAddress)login", info: ["username" : username, "password" : password]) { [unowned self] (info: AnyObject?, error: NSError?)  in
            
            if error == nil && info != nil {
                self.loginInfo = LoginInfo(loginInfo: info as! [String : AnyObject], password: password)
            }
            complete(self.loginInfo, error)
        }
    }
    
    public func register(username: String, password: String, name: String, complete: (LoginInfo?, NSError?) -> Void) {
        Request.sendJsonRequest("\(loginServerAddress)register", info: ["username" : username, "password" : password, "name" : name]) { (info: AnyObject?, error: NSError?) in
            
            var loginInfo: LoginInfo? = nil
            if error == nil && info != nil {
                loginInfo = LoginInfo(loginInfo: info as! [String : AnyObject], password: password)
            }
            complete(loginInfo, error)
        }
    }
    
    public func logout() {
        loginInfo = nil
    }
    
    public func searchUsers(keyword: String, complete: (([[String : AnyObject]]?, NSError?) -> Void)) {
        Request.sendJsonRequest("\(loginServerAddress)searchBuddyKeyword", info: ["keyword" : keyword]) { (info: AnyObject?, error: NSError?) in
            complete(info as? [[String : AnyObject]], error)
        }
    }
    
    public func addBuddys(buddyIds: [Int], complete: (NSError?) -> Void) {
        
        if loginInfo == nil {
            complete(NSError(domain: "LoginServer Error addBuddy", code: 10001, userInfo: [NSLocalizedDescriptionKey : "not login"]))
            return
        }
        
        Request.sendJsonRequest("\(loginServerAddress)addBuddys", info: ["userId" : "\(self.loginInfo!.userId)", "buddyIds" : buddyIds]) { (info: AnyObject?, error: NSError?) in
            complete(error)
        }
    }
    
    public func removeBuddys(buddyIds: [Int], complete: (NSError?) -> Void) {
        if loginInfo == nil {
            complete(NSError(domain: "LoginServer Error removeBuddys", code: 10001, userInfo: [NSLocalizedDescriptionKey : "not login"]))
            return
        }
        
        Request.sendJsonRequest("\(loginServerAddress)removeBuddys", info: ["userId" : "\(self.loginInfo!.userId)", "buddyIds" : buddyIds]) { (info: AnyObject?, error: NSError?) in
            complete(error)
        }
    }
    
    public func queryBuddys(complete: (([[String : AnyObject]]?, NSError?) -> Void)) {
        if loginInfo == nil {
            complete(nil, NSError(domain: "LoginServer Error queryBuddys", code: 10001, userInfo: [NSLocalizedDescriptionKey : "not login"]))
            return
        }
        
        Request.sendJsonRequest("\(loginServerAddress)queryBuddys", info: ["userId" : "\(self.loginInfo!.userId)"]) { (info: AnyObject?, error: NSError?) in
            complete(info as? [[String : AnyObject]], error)
        }
    }
}

public struct LoginInfo {
    public var username: String
    public var name: String
    public var userId: Int
    public var password: String
    public var buddyIds: [Int]
    
    init (loginInfo: [String : AnyObject], password: String) {
        self.username = loginInfo["username"] as! String
        self.name = loginInfo["name"] as! String
        self.userId = loginInfo["userId"] as! Int
        self.password = password
        self.buddyIds = loginInfo["buddyIds"] as! [Int];
    }
}