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
                    
                    msgModel.insertDB()
                    
                    if msgModel.sessionId == nil {
                        if !SessionModel.checkExist(sessionId: "\(msgModel.fromUserId)") {
                            let sessionModel = SessionModel(type: SessionType.Buddy, sessionId: "\(msgModel.fromUserId)", sessionName: "\(msgModel.fromUserId)")
                        }
                    }
                    
                    
                    self.delegate?.receiveNewMsg(msgModel)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MsgService.receiveMessageNotificationName), object: msgModel, userInfo: nil)
                }
            }
            
//            self.delegate?.receiveNewMsg(MsgModel(fromId: <#T##Int#>, toId: <#T##Int#>, contentStr: <#T##String#>, msgContentType: <#T##Int#>, sessionId: <#T##String?#>)
        })
        
        socket?.connect()
    }
    
    open func sendMessage(_ model: MsgModel, complete: ((NSError?) -> Void)?) {
        socket?.emit("message", model.toSendData() as! SocketData)
        model.insertDB()
    }
}

// MARK: - Session
extension MsgService {
    func queryAllSessionModels() -> [SessionModel] {
        return SessionDBModel.queryAllSession()
    }
}
