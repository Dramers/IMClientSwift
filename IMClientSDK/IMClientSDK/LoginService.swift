//
//  LoginService.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

open class LoginService: NSObject {
    open var loginServerAddress = "http://127.0.0.1:3002/"
    
    open static let shareInstance = LoginService()
    
    open static var isLogin: Bool {
        return LoginService.shareInstance.loginInfo != nil
    }
    open var loginInfo: LoginInfo?
    
    open func login(_ username: String, password: String, complete: @escaping (LoginInfo?, NSError?) -> Void) {
        
        Request.sendJsonRequest("\(loginServerAddress)login", jsonInfo: ["username" : username as AnyObject, "password" : password]) { [unowned self] (info: AnyObject?, error: NSError?)  in
            
            if error == nil && info != nil {
                self.loginInfo = LoginInfo(loginInfo: info as! [String : AnyObject], password: password)
                
                // 连接消息服务器
                
                MsgService.shareInstance.connect(self.loginInfo!.msgServerAddress!, userId: self.loginInfo!.userId)
            }
            complete(self.loginInfo, error)
        }
    }
    
    open func register(_ username: String, password: String, name: String, complete: @escaping (LoginInfo?, NSError?) -> Void) {
        Request.sendJsonRequest("\(loginServerAddress)register", jsonInfo: ["username" : username, "password" : password, "name" : name]) { (info: AnyObject?, error: NSError?) in
            
            var loginInfo: LoginInfo? = nil
            if error == nil && info != nil {
                loginInfo = LoginInfo(loginInfo: info as! [String : AnyObject], password: password)
            }
            complete(loginInfo, error)
        }
    }
    
    open func logout() {
        loginInfo = nil
    }
    
    open func searchUsers(_ keyword: String, complete: @escaping (([[String : AnyObject]]?, NSError?) -> Void)) {
        Request.sendJsonRequest("\(loginServerAddress)searchBuddyKeyword", jsonInfo: ["keyword" : keyword]) { (info: AnyObject?, error: NSError?) in
            complete(info as? [[String : AnyObject]], error)
        }
    }
    
    open func addBuddys(_ buddyIds: [Int], complete: @escaping (NSError?) -> Void) {
        
        if loginInfo == nil {
            complete(NSError(domain: "LoginServer Error addBuddy", code: 10001, userInfo: [NSLocalizedDescriptionKey : "not login"]))
            return
        }
        
        Request.sendJsonRequest("\(loginServerAddress)addBuddys", jsonInfo: ["userId" : "\(self.loginInfo!.userId)", "buddyIds" : buddyIds]) { (info: AnyObject?, error: NSError?) in
            complete(error)
        }
    }
    
    open func removeBuddys(_ buddyIds: [Int], complete: @escaping (NSError?) -> Void) {
        if loginInfo == nil {
            complete(NSError(domain: "LoginServer Error removeBuddys", code: 10001, userInfo: [NSLocalizedDescriptionKey : "not login"]))
            return
        }
        
        Request.sendJsonRequest("\(loginServerAddress)removeBuddys", jsonInfo: ["userId" : "\(self.loginInfo!.userId)", "buddyIds" : buddyIds]) { (info: AnyObject?, error: NSError?) in
            complete(error)
        }
    }
    
    open func queryBuddys(_ complete: @escaping (([[String : AnyObject]]?, NSError?) -> Void)) {
        if loginInfo == nil {
            complete(nil, NSError(domain: "LoginServer Error queryBuddys", code: 10001, userInfo: [NSLocalizedDescriptionKey : "not login"]))
            return
        }
        
        Request.sendJsonRequest("\(loginServerAddress)queryBuddys", jsonInfo: ["userId" : "\(self.loginInfo!.userId)"]) { (info: AnyObject?, error: NSError?) in
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
    var msgServerAddress: String?
    
    init (loginInfo: [String : AnyObject], password: String) {
        self.username = loginInfo["username"] as! String
        self.name = loginInfo["name"] as! String
        self.userId = loginInfo["userId"] as! Int
        self.password = password
        self.buddyIds = loginInfo["buddyIds"] as! [Int];
        self.msgServerAddress = loginInfo["msgServerAddress"] as? String
    }
}
