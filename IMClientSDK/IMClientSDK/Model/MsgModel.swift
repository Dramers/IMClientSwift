//
//  MsgModel.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/17.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public struct MsgModel {

    public var fromUserId: Int
    public var toUserId: Int
    public var contentStr: String
    public var msgId: String
    public var serverReceiveDate: Date?
    public var sendDate: Date
    public var msgContentType: Int
    public var sessionId: String?
    public var state: Int
    
    public init( fromId: Int, toId: Int, contentStr: String, msgContentType: Int, sessionId: String?) {
        fromUserId = fromId
        toUserId = toId
        self.contentStr = contentStr
        msgId = UUID().uuidString
        sendDate = Date()
        self.msgContentType = msgContentType
        self.sessionId = sessionId
        state = 1
    }
    
    func toSendData() -> AnyObject {
        var sendData = [
            "fromUserId" : NSNumber(value: fromUserId as Int),
            "toUserId" : NSNumber(value: toUserId as Int),
            "contentStr" : contentStr,
            "msgId" : msgId,
            "sendDate" : NSNumber(value: sendDate.timeIntervalSince1970 as Double),
            "msgContentType" : NSNumber(value: msgContentType as Int),
            "state" : NSNumber(value: state as Int)
        ] as [String : Any]
        
        if serverReceiveDate != nil {
            sendData["serverReceiveDate"] = NSNumber(value: serverReceiveDate!.timeIntervalSince1970 as Double)
        }
        
        if sessionId != nil {
            sendData["sessionId"] = sessionId
        }
        
        return sendData as AnyObject
    }
}
