//
//  SessionModel.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/17.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

enum SessionType: Int {
    case Group
    case Buddy
}

struct SessionModel {
    var type: SessionType
    
    var sessionId: String
    var sessionName: String
}

extension SessionModel {
    static func queryAllSession() -> [SessionModel] {
        return SessionDBModel.queryAllSession()
    }
    
    static func checkExist(sessionId: String) -> Bool {
        if let _ = SessionDBModel.querySession(sessionId: sessionId) {
            return true
        }
        
        return false
    }
}
