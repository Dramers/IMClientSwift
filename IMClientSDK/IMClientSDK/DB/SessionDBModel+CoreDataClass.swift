//
//  SessionDBModel+CoreDataClass.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/10/13.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData


class SessionDBModel: NSManagedObject {
    
    class func insertDB(model: SessionModel) {
        // 插入一个新的
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let insertData = NSEntityDescription.insertNewObject(forEntityName: "SessionDBModel", into: context) as! SessionDBModel
        
        insertData.type = Int16(model.type.rawValue)
        insertData.sessionId = model.sessionId
        insertData.sessionName = model.sessionName
        
        do {
            try context.save()
            NSLog("Insert SessionDBModel Data Success. sessionId: \(model.sessionId)")
        } catch _ {
            NSLog("Insert SessionDBModel Data Fail.  sessionId: \(model.sessionId)")
        }
    }
    
    class func querySession(sessionId: String) -> SessionModel? {
        
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "SessionDBModel", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        request.predicate = NSPredicate(format: "sessionId == %@", sessionId)
        request.fetchLimit = 1
        
        if let listData = (try? context.fetch(request)) as? [SessionDBModel] {
            for managedObject in listData {
                return self.convertModel(managedObject)
            }
        }
        
        return nil
    }
    
    class func queryAllSession() -> [SessionModel] {
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "SessionDBModel", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        
        var datas: [SessionModel] = []
        if let listData = (try? context.fetch(request)) as? [SessionDBModel] {
            for managedObject in listData {
                
                datas += [self.convertModel(managedObject)]
            }
        }
        
        return datas
    }
    
    class func convertModel(_ dbModel: SessionDBModel) -> SessionModel {
        let type = SessionType(rawValue: (dbModel.value(forKey: "type") as! NSNumber).intValue)!
        let sessionId = dbModel.value(forKey: "sessionId") as! String
        let sessionName = dbModel.value(forKey: "sessionName") as! String
        
        return SessionModel(type: type, sessionId: sessionId, sessionName: sessionName)
    }
}
