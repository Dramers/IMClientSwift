//
//  UserModel.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/17.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

struct UserModel {
    var userId: Int
    var name: String
    var headURLStr: String?
    
    init(info: [String : AnyObject]) {
        userId = info["userId"] as! Int
        name = info["name"] as! String
        headURLStr = info["headURLStr"] as? String
    }
}
