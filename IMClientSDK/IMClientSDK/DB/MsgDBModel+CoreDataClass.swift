//
//  MsgDBModel+CoreDataClass.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/24.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData


class MsgDBModel: NSManagedObject {
    class func insertDB(msgModel: MsgModel) {
        // 插入一个新的
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let insertData = NSEntityDescription.insertNewObject(forEntityName: "MsgDBModel", into: context) as! MsgDBModel
        
        insertData.fromUserId = Int64(msgModel.fromUserId)
        insertData.toUserId = Int64(msgModel.toUserId)
        insertData.contentStr = msgModel.contentStr
        insertData.msgId = msgModel.msgId
        if let date = msgModel.serverReceiveDate {
            insertData.serverReceiveDate = date as NSDate?
        }
        
        insertData.sendDate = msgModel.sendDate as NSDate
        insertData.msgContentType = Int16(msgModel.msgContentType)
        insertData.sessionId = msgModel.sessionId
        insertData.state = Int16(msgModel.state)
        
        do {
            try context.save()
            NSLog("Insert Msg Data Success. msgId: \(msgModel.msgId)")
        } catch _ {
            NSLog("Insert Msg Data Fail.  msgId: \(msgModel.msgId)")
        }
    }
}
