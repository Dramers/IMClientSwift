//
//  ClientMsgDB.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/24.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation
import CoreData

class ClientMsgDB: NSObject {
    let storeName = "ClientMsgDB"
    let storeFilename = "ClientMsgDB.sqlite"
    
    lazy var applicationDocumentsDirectory: URL = {
        let url = NSHomeDirectory() + "/Documents/"
        return URL(fileURLWithPath: url)
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
}
