//
//  LoginService.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public class LoginService: NSObject {
    public var loginServerAddress = "http://127.0.0.1:3001/users/"
    
    public static let shareInstance = LoginService()
    
    public static var isLogin: Bool {
        return LoginService.shareInstance.loginInfo != nil
    }
    public var loginInfo: LoginInfo?
    
    public func login(username: String, password: String, complete: (LoginInfo?, NSError?) -> Void) {
        
        Request.sendJsonRequest("\(loginServerAddress)login", info: ["username" : username, "password" : password]) { [unowned self] (info: [String : AnyObject]?, error: NSError?)  in
            
            if error == nil && info != nil {
                self.loginInfo = LoginInfo(loginInfo: info!, password: password)
            }
            complete(self.loginInfo, error)
        }
    }
    
    public func register(username: String, password: String, name: String, complete: (LoginInfo?, NSError?) -> Void) {
        Request.sendJsonRequest("\(loginServerAddress)register", info: ["username" : username, "password" : password, "name" : name]) { (info: [String : AnyObject]?, error: NSError?) in
            
            var loginInfo: LoginInfo? = nil
            if error == nil && info != nil {
                loginInfo = LoginInfo(loginInfo: info!, password: password)
            }
            complete(loginInfo, error)
        }
    }
    
    public func logout() {
        loginInfo = nil
    }
}

public struct LoginInfo {
    public var username: String
    public var name: String
    public var userId: Int
    public var password: String
    
    init (loginInfo: [String : AnyObject], password: String) {
        self.username = loginInfo["username"] as! String
        self.name = loginInfo["name"] as! String
        self.userId = loginInfo["userId"] as! Int
        self.password = password
    }
}