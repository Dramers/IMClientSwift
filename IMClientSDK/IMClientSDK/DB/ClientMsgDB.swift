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
    
    static let sharedInstance = ClientMsgDB()
    
    lazy var applicationDocumentsDirectory: URL = {
        let url = NSHomeDirectory() + "/Documents/"
        return URL(fileURLWithPath: url)
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        /*
         if (!mergedManagedObjectModel)
         {
         NSMutableSet *allBundles = [[[NSMutableSet alloc] init] autorelease];
         [allBundles addObjectsFromArray: [NSBundle allBundles]];
         [allBundles addObjectsFromArray: [NSBundle allFrameworks]];
         
         mergedManagedObjectModel = [[NSManagedObjectModel mergedModelFromBundles: [allBundles allObjects]] retain];
         }
         
         return mergedManagedObjectModel;
         */
//        return NSManagedObjectModel.mergedModel(from: Bundle.allFrameworks)!
        
        let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
