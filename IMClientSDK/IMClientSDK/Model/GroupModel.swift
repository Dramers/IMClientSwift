//
//  GroupModel.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/11/10.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public struct GroupModel {
    
    public var groupId: String
    public var groupName: String
    public var creator: Int
    public var groupHeadImage: String?
    public var memberIds: [Int]
    public var updateDate: Date
    public var createDate: Date
    
    init(info: [String : Any]) {
        groupId = info["groupId"] as! String
        groupName = info["groupName"] as! String
        creator = (info["creator"] as! NSNumber).intValue
        groupHeadImage = info["groupHeadImage"] as? String
        
        memberIds = []
        if let tempMembers = info["memberIds"] as? [NSNumber] {
            for memberId in tempMembers {
                memberIds.append(memberId.intValue)
            }
        }
        
        updateDate = Date(timeIntervalSince1970: TimeInterval(info["updateDate"] as! NSNumber))
        createDate = Date(timeIntervalSince1970: TimeInterval(info["createDate"] as! NSNumber))
    }
}
