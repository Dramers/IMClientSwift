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
        insertData.serverReceiveDate = msgModel.serverReceiveDate as NSDate
        
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
    
    class func queryMessages(sessionId: String, start: Int, size: Int) -> [MsgModel] {
        
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "MsgDBModel", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        request.predicate = NSPredicate(format: "sessionId == %@", sessionId)
        let endDateSort = NSSortDescriptor(key: "serverReceiveDate", ascending: false)
        request.sortDescriptors = [endDateSort]
        request.fetchLimit = size
        request.fetchOffset = start
        
        let listData = (try! context.fetch(request)) as! [MsgDBModel]
        
        var datas: [MsgModel] = []
        for managedObject in listData {
            datas += [convertModel(managedObject)]
        }
        return datas
    }
    
    class func convertModel(_ dbModel: MsgDBModel) -> MsgModel {
        
        let fromUserId = dbModel.value(forKey: "fromUserId") as! NSNumber
        let toUserId = dbModel.value(forKey: "toUserId") as! NSNumber
        let contentStr = dbModel.value(forKey: "contentStr") as! String
        let msgId = dbModel.value(forKey: "msgId") as! String
        
        let serverReceiveDate = (dbModel.value(forKey: "serverReceiveDate") as! Date)
        let sendDate = (dbModel.value(forKey: "sendDate") as! Date)
        let msgContentType = dbModel.value(forKey: "msgContentType") as! NSNumber
        let sessionId = dbModel.value(forKey: "sessionId") as? String
        let state = dbModel.value(forKey: "state") as! NSNumber
        
        var msgModel = MsgModel(fromId: fromUserId.intValue, toId: toUserId.intValue, contentStr: contentStr, msgContentType: msgContentType.intValue, sessionId: sessionId)
        msgModel.msgId = msgId
        msgModel.serverReceiveDate = serverReceiveDate
        msgModel.sendDate = sendDate
        msgModel.state = state.intValue
        
        return msgModel
    }
}
