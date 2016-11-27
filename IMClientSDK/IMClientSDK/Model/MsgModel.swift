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
    public var serverReceiveDate: Date
    public var sendDate: Date
    public var msgContentType: Int // 1为纯文本
    public var sessionId: String?
    public var sessionName: String?
    public var state: Int
    
    public init( fromId: Int, toId: Int, contentStr: String, msgContentType: Int, sessionId: String?) {
        fromUserId = fromId
        toUserId = toId
        self.contentStr = contentStr
        msgId = UUID().uuidString
        sendDate = Date()
        serverReceiveDate = Date()
        self.msgContentType = msgContentType
        self.sessionId = sessionId
        state = 1
    }
    
    public init(info: [String : Any]) {
        
        fromUserId = info["fromUserId"] as! Int
        toUserId = info["toUserId"] as! Int
        contentStr = info["contentStr"] as! String
        msgContentType = info["msgContentType"] as! Int
        sessionId = info["sessionId"] as? String
        
        msgId = info["msgId"] as! String
        sendDate = Date(timeIntervalSince1970: info["sendDate"] as! TimeInterval)
        serverReceiveDate = Date(timeIntervalSince1970: info["serverReceiveDate"] as! TimeInterval)
        state = info["state"] as! Int
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
        
        sendData["serverReceiveDate"] = NSNumber(value: serverReceiveDate.timeIntervalSince1970 as Double)
        
        if sessionId != nil {
            sendData["sessionId"] = sessionId
        }
        
        return sendData as AnyObject
    }
}

// DB Method
extension MsgModel {
    func insertDB() {
        MsgDBModel.insertDB(msgModel: self)
    }
    
    public static func querySessionMsg(sessionId: String, start: Int, size: Int) -> [MsgModel] {
        return MsgDBModel.queryMessages(sessionId: sessionId, start: start, size: size)
    }
}
