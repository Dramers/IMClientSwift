//
//  UserModel.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/17.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public  struct UserModel {
    public  var userId: Int
    public  var name: String
    public  var headURLStr: String?
    public  var buddyIds: [Int] = []
    
    public  init(userId: Int, name: String, headURLStr: String?) {
        self.userId = userId
        self.name = name
        self.headURLStr = headURLStr
    }
    
    init(info: [String : AnyObject]) {
        userId = info["userId"] as! Int
        name = info["name"] as! String
        headURLStr = info["headURLStr"] as? String
        
        if let buddys = info["buddyIds"] as? [Int] {
            buddyIds = buddys
        }
        
    }
}


extension UserModel {
    
    static func queryUser(userId: Int, complete: @escaping (UserModel?) -> Void) {
        
        // 本地
        if let userModel = UserDBModel.queryUser(userId: userId) {
            complete(userModel)
            return
        }
        
        LoginService.shareInstance.queryUserInfo(userId: userId) { (userModel: UserModel?, error: NSError?) in
            
            userModel?.insertDB()
            complete(userModel)
        }
    }
    
    func insertDB() {
        UserDBModel.insertDB(model: self)
    }
    
    init?(userId: Int) {
        return nil
    }
}
