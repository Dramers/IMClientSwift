//
//  SessionDBModel+CoreDataProperties.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/10/13.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData


extension SessionDBModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionDBModel> {
        return NSFetchRequest<SessionDBModel>(entityName: "SessionDBModel");
    }

    @NSManaged public var type: Int16
    @NSManaged public var sessionId: String?
    @NSManaged public var sessionName: String?

}
