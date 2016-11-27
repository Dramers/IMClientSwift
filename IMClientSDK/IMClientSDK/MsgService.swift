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
    var socket: SocketIOClient?
    var userId: Int?
    var offlineComplete: (([MsgModel]?, NSError?) -> Void)?
    
    open static let receiveMessageNotificationName = "kreceiveMessageNotificationName"
    open var delegate: MsgServiceDelegate?
    
    open func connect(_ socketURLStr: String, userId: Int, complete: @escaping (NSError?) -> Void) {
        
        self.userId = userId
        
        socket = SocketIOClient(socketURL: URL(string: socketURLStr)! ,config: [.log(true), .forcePolling(true)])
        
        socket?.on("connect") { [unowned self] data, ack in
            print ("socket connected")
            
            self.socket?.emit("getUserId", userId)
            
            GroupService.shareInstance.listenEvent(socket: self.socket!)
            
            complete(nil)
            
            // 获取离线消息
            self.queryOfflineMsgs { [unowned self] (msgModels: [MsgModel]?, error: NSError?) in
                if msgModels != nil {
                    self.dealReceivesMsgs(msgModels: msgModels!)
                }
            }
        }
        socket?.on("disconnect", callback: { (data: [Any], ack: SocketAckEmitter) in
            print("socket disconnect")
        })
        
        socket?.on("message", callback: { (datas: [Any], ack: SocketAckEmitter) in
            print("receive data \(datas)")
            
            self.dealReceivesMsgs(msgModels: self.parseMsgDatas(datas: datas))
        })
        
        socket?.on("queryOffineMessage", callback: { (info: [Any], ack: SocketAckEmitter) in
            
            if let responseInfo = info.first as? [String : Any] {
                
                if let code = responseInfo["code"] as? Int
                {
                    if code == 0 {
                        let msgModels = self.parseOfflineMsgs(result: responseInfo["result"] as! [Any])
                        self.offlineComplete?(msgModels, nil)
                    }
                    else {
                        let msg = responseInfo["result"] as! String
                        let err = NSError(domain: "GroupService Server Error", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
                        self.offlineComplete?(nil, err)
                    }
                    
                    self.offlineComplete = nil
                }
            }
        })
        
        socket?.connect()
    }
    
    open func sendMessage(_ model: MsgModel, complete: ((NSError?) -> Void)?) {
        socket?.emit("message", model.toSendData() as! SocketData)
        
        querySessionModel(msgModel: model, isSend: true, complete: { [unowned self] (sessionModel: SessionModel?) in
            
            if var session = sessionModel {
                session.lastMsgContent = model.contentStr
                session.updateDB()
                
                var dbModel = model
                dbModel.sessionId = session.sessionId
                dbModel.insertDB()
                self.notificationReceiveNewMsg(msgModel: dbModel, sessionModel: session)
            }
        })
    }
    
    open func queryOfflineMsgs(complete: (([MsgModel]?, NSError?) -> Void)?) {
        self.offlineComplete = complete
        socket?.emit("queryOffineMessage", ["userId" : userId!]);
    }
    
    
}

// MARK: - Msgs
extension MsgService {
    
    func parseMsgDatas(datas: [Any]) -> [MsgModel] {
        
        var msgModels: [MsgModel] = []
        
        for data in datas {
            if let info = data as? [String: Any] {
                msgModels.append(MsgModel(info: info))
            }
        }
        
        return msgModels
    }
    
    func dealReceivesMsgs(msgModels: [MsgModel]) {
        for var msgModel in msgModels {
            
            self.querySessionModel(msgModel: msgModel, isSend: false, complete: { (sessionModel: SessionModel?) in
                
                if var session = sessionModel {
                    
                    session.lastMsgContent = msgModel.contentStr
                    session.unreadCount += 1
                    session.updateDB()
                    
                    if session.type == .buddy {
                        msgModel.sessionId = session.sessionId
                    }
                    msgModel.insertDB()
                    
                    self.notificationReceiveNewMsg(msgModel: msgModel, sessionModel: session)
                    
                }
                
            })
        }
    }
    
    func parseOfflineMsgs(result: [Any]) -> [MsgModel] {
        
        var msgModels: [MsgModel] = []
        
        for data in result {
            
            if let info = data as? [String : Any] {
                
                let labelName = info["labelName"] as? String
                let content = info["content"] as? [String : Any]
                
                if labelName != nil && content != nil {
                    
                    if labelName == "message" {
                        msgModels.append(MsgModel(info: content!))
                    }
                    else if labelName == "messageStatus" {
                        
                    }
                    else if labelName == "deleteGroupNoti" {
                        
                    }
                    else if labelName == "createGroupNoti" {
                        
                    }
                    else if labelName == "groupMembersAddNoti" {
                        
                    }
                    else if labelName == "groupMembersDelNoti" {
                        
                    }
                    else if labelName == "groupInfoUpdateNoti" {
                        
                    }
                    else {
                        
                    }
                }
            }
        }
        
        return msgModels
    }
    
    func notificationReceiveNewMsg(msgModel: MsgModel, sessionModel: SessionModel) {
        self.delegate?.receiveNewMsg(msgModel)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MsgService.receiveMessageNotificationName), object: msgModel, userInfo: ["session" : sessionModel])
    }
}

// MARK: - Session
extension MsgService {
    func queryAllSessionModels() -> [SessionModel] {
        return SessionDBModel.queryAllSession()
    }
    
    func querySessionModel(msgModel: MsgModel, isSend: Bool, complete:((SessionModel?) -> Void)? ) {
        if msgModel.sessionId == nil {
            
            if let sessinModel = SessionModel(sessionId: "\(isSend ? msgModel.toUserId : msgModel.fromUserId)") {
                complete?(sessinModel)
                return
            }
        }
        else {
            if let sessinModel = SessionModel(sessionId: msgModel.sessionId!) {
                complete?(sessinModel)
                return
            }
        }
        
        UserModel.queryUser(userId: msgModel.fromUserId, complete: { (userModel: UserModel?) in
            
            if userModel != nil {
                let sessionModel = SessionModel(type: SessionType.buddy, sessionId: "\(isSend ? msgModel.toUserId : msgModel.fromUserId)", sessionName: "\(userModel!.name)", unreadCount: 0, lastMsgContent: msgModel.contentStr)
                
                complete?(sessionModel)
            }
            else{
                complete?(nil)
            }
        })
    }
}
