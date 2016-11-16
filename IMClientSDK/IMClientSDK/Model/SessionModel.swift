//
//  SessionModel.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/17.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public enum SessionType: Int {
    case group
    case buddy
}

public struct SessionModel {
    public var type: SessionType
    
    public var sessionId: String
    public var sessionName: String
    public var unreadCount: Int
    public var lastMsgContent: String
}

extension SessionModel {
    public static func queryAllSession() -> [SessionModel] {
        return SessionDBModel.queryAllSession()
    }
    
    public static func checkExist(sessionId: String) -> Bool {
        if let _ = SessionDBModel.querySession(sessionId: sessionId) {
            return true
        }
        
        return false
    }
    
    public init?(sessionId: String) {
        if let sessionModel = SessionDBModel.querySession(sessionId: sessionId) {
            type = sessionModel.type
            self.sessionId = sessionId
            sessionName = sessionModel.sessionName
            unreadCount = sessionModel.unreadCount
            lastMsgContent = sessionModel.lastMsgContent
        }
        else {
            return nil
        }
    }
    
    public init(userModel: UserModel) {
        
        if let sessionModel = SessionDBModel.querySession(sessionId: "\(userModel.userId)") {
            self = sessionModel
        }
        else {
            type = .buddy
            sessionId = "\(userModel.userId)"
            sessionName = userModel.name
            unreadCount = 0
            lastMsgContent = ""
        }
    }
    
    public init(groupModel: GroupModel) {
        
        if let sessionModel = SessionDBModel.querySession(sessionId: groupModel.groupId) {
            self = sessionModel
        }
        else {
            type = .group
            sessionId = groupModel.groupId
            sessionName = groupModel.groupName
            unreadCount = 0
            lastMsgContent = ""
        }
    }
    
    func insertDB() {
        SessionDBModel.insertDB(model: self)
    }
    
    func updateDB() {
        SessionDBModel.updateDB(model: self)
    }
}
