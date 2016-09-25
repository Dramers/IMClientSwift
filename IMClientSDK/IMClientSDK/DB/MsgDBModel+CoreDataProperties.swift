//
//  MsgDBModel+CoreDataProperties.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/24.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData


extension MsgDBModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MsgDBModel> {
        return NSFetchRequest<MsgDBModel>(entityName: "MsgDBModel");
    }

    @NSManaged public var fromUserId: Int64
    @NSManaged public var toUserId: Int64
    @NSManaged public var contentStr: String?
    @NSManaged public var msgId: String?
    @NSManaged public var serverReceiveDate: NSDate?
    @NSManaged public var sendDate: NSDate?
    @NSManaged public var msgContentType: Int16
    @NSManaged public var sessionId: String?
    @NSManaged public var state: Int16

}
