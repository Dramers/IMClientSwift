//
//  UserDBModel+CoreDataProperties.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/10/14.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData


extension UserDBModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDBModel> {
        return NSFetchRequest<UserDBModel>(entityName: "UserDBModel");
    }

    @NSManaged public var userId: Int64
    @NSManaged public var name: String?
    @NSManaged public var headURLStr: String?

}
