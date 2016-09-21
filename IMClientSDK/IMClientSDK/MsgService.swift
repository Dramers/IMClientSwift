//
//  MsgService.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public protocol MsgServiceDelegate {
    func receiveNewMsg(_ msg: MsgModel)
}

open class MsgService: NSObject {
    open static let shareInstance = MsgService()
    fileprivate var socket: SocketIOClient?
    
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
        
        socket?.on("message", callback: { (data: [Any], ack: SocketAckEmitter) in
            print("receive data \(data)")
            
//            self.delegate?.receiveNewMsg(MsgModel(fromId: <#T##Int#>, toId: <#T##Int#>, contentStr: <#T##String#>, msgContentType: <#T##Int#>, sessionId: <#T##String?#>)
        })
        
        socket?.connect()
    }
    
    open func sendMessage(_ model: MsgModel, complete: ((NSError?) -> Void)?) {
        socket?.emit("message", model.toSendData() as! SocketData)
    }
}
