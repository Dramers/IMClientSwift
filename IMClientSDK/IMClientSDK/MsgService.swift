//
//  MsgService.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import Foundation

public protocol MsgServiceDelegate {
    func receiveNewMsg(_ msg: MsgModel)
}

open class MsgService: NSObject {
    open static let shareInstance = MsgService()
    fileprivate var socket: SocketIOClient?
    
    open static let receiveMessageNotificationName = "kreceiveMessageNotificationName"
    open var delegate: MsgServiceDelegate?
    
    open func connect(_ socketURLStr: String, userId: Int) {
        socket = SocketIOClient(socketURL: URL(string: socketURLStr)! ,config: [.log(true), .forcePolling(true)])
        
        socket?.on("connect") { [unowned self] data, ack in
            print ("socket connected")
            
            self.socket?.emit("getUserId", userId)
        }
        socket?.on("disconnect", callback: { (data: [Any], ack: SocketAckEmitter) in
            print("socket disconnect")
        })
        
        socket?.on("message", callback: { (datas: [Any], ack: SocketAckEmitter) in
            print("receive data \(datas)")
            
            /*
             {
                contentStr = helloWorld;
                fromUserId = 6;
                msgContentType = 1;
                msgId = "768D2D05-046C-4E3C-B39A-04FC5A0245DE";
                sendDate = "1474811811.949114";
                serverReceiveDate = 1474811812153;
                state = 1;
                toUserId = 7;
             }
             */
            for data in datas {
                
                if let info = data as? [String: Any] {
                    var msgModel = MsgModel(fromId: info["fromUserId"] as! Int, toId: info["toUserId"] as! Int, contentStr: info["contentStr"] as! String, msgContentType: info["msgContentType"] as! Int, sessionId: info["sessionId"] as? String)
                    
                    msgModel.msgId = info["msgId"] as! String
                    msgModel.sendDate = Date(timeIntervalSince1970: info["sendDate"] as! TimeInterval)
                    msgModel.serverReceiveDate = Date(timeIntervalSince1970: info["serverReceiveDate"] as! TimeInterval)
                    msgModel.state = info["state"] as! Int
                    
                    
                    
                    if msgModel.sessionId == nil {
                        
                        msgModel.sessionId = "\(msgModel.fromUserId)"
                        msgModel.insertDB()
                        
                        if var sessionModel = SessionModel(sessionId: "\(msgModel.fromUserId)") {
                            sessionModel.lastMsgContent = msgModel.contentStr
                            sessionModel.unreadCount += 1
                            sessionModel.updateDB()
                            
                            self.notificationReceiveNewMsg(msgModel: msgModel, sessionModel: sessionModel)
                        }
                        else {
//                            if let userModel =
                            UserModel.queryUser(userId: msgModel.fromUserId, complete: { (userModel: UserModel?) in
                                
                                if userModel != nil {
                                    let sessionModel = SessionModel(type: SessionType.buddy, sessionId: "\(msgModel.fromUserId)", sessionName: "\(userModel!.name)", unreadCount: 0, lastMsgContent: msgModel.contentStr)
                                    sessionModel.insertDB()
                                    
                                    self.notificationReceiveNewMsg(msgModel: msgModel, sessionModel: sessionModel)
                                }
                                
                            })
                            
                        }
                        
                        
                    }
                    else {
                        msgModel.insertDB()
                    }
                    
                    
                }
            }
        })
        
        socket?.connect()
    }
    
    func notificationReceiveNewMsg(msgModel: MsgModel, sessionModel: SessionModel) {
        self.delegate?.receiveNewMsg(msgModel)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MsgService.receiveMessageNotificationName), object: msgModel, userInfo: ["session" : sessionModel])
    }
    
    open func sendMessage(_ model: MsgModel, complete: ((NSError?) -> Void)?) {
        socket?.emit("message", model.toSendData() as! SocketData)
        
        if var sessionModel = sessionModel(msgModel: model, isSend: true) {
            
            sessionModel.lastMsgContent = model.contentStr
            sessionModel.updateDB()
            
            var dbModel = model
            dbModel.sessionId = sessionModel.sessionId
            dbModel.insertDB()
            self.notificationReceiveNewMsg(msgModel: dbModel, sessionModel: sessionModel)
        }
    }
    
    func sessionModel(msgModel: MsgModel, isSend: Bool) -> SessionModel? {
        if msgModel.sessionId == nil {
            
            if let sessinModel = SessionModel(sessionId: "\(isSend ? msgModel.toUserId : msgModel.fromUserId)") {
                return sessinModel
            }
        }
        else {
            if let sessinModel = SessionModel(sessionId: msgModel.sessionId!) {
                return sessinModel
            }
        }
        
        return nil
    }
}



// MARK: - Session
extension MsgService {
    func queryAllSessionModels() -> [SessionModel] {
        return SessionDBModel.queryAllSession()
    }
}
