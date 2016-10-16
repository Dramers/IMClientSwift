//
//  UserDBModel+CoreDataClass.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/10/14.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData


class UserDBModel: NSManagedObject {

    class func queryUser(userId: Int) -> UserModel? {
        
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserDBModel", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        request.predicate = NSPredicate(format: "userId == %d", userId)
        request.fetchLimit = 1
        
        if let listData = (try? context.fetch(request)) as? [UserDBModel] {
            for managedObject in listData {
                return self.convertModel(managedObject)
            }
        }
        
        return nil
    }
    
    class func insertDB(model: UserModel) {
        // 插入一个新的
        let context = ClientMsgDB.sharedInstance.managedObjectContext
        let insertData = NSEntityDescription.insertNewObject(forEntityName: "UserDBModel", into: context) as! UserDBModel
        
        insertData.userId = Int64(model.userId)
        insertData.name = model.name
        if model.headURLStr != nil {
            insertData.headURLStr = model.headURLStr
        }
        
        do {
            try context.save()
            NSLog("Insert UserDBModel Data Success. userId: \(model.userId)")
        } catch _ {
            NSLog("Insert UserDBModel Data Fail.  userId: \(model.userId)")
        }
    }
    
    class func convertModel(_ dbModel: UserDBModel) -> UserModel {
//        var name: String
//        var headURLStr: String?
        
        let userId = dbModel.value(forKey: "userId") as! NSNumber
        let name = dbModel.value(forKey: "name") as! String
        var headURLStr: String? = nil
        if let str = dbModel.value(forKey: "headURLStr") as? String {
            headURLStr = str
        }
        
        return UserModel(userId: userId.intValue, name: name, headURLStr: headURLStr)
    }
}
