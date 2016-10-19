//
//  ChatViewModel.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/24.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class ChatViewModel: NSObject {
    
    var sessionId: String = ""
    var messages: [MsgModel] = []
    var start: Int = 0
    let size: Int = 10
    
    lazy var sessionModel: SessionModel = SessionModel(sessionId: self.sessionId)!
    
    func reloadMsgs() {
        self.messages = MsgModel.querySessionMsg(sessionId: sessionId, start: 0, size: size)
        start = size
    }
    
    func reloadCurrentMsgs() {
        self.messages = MsgModel.querySessionMsg(sessionId: sessionId, start: 0, size: messages.count + 1)
        start += 1
    }
    
    func loadMoreMsgs() {
        let oldMsgs = MsgModel.querySessionMsg(sessionId: sessionId, start: start, size: size)
        
        self.messages = oldMsgs + messages
        start = messages.count
    }
    
    func textMsg(text: String) -> MsgModel {
        
        var toId: Int = 0
        if sessionModel.type == .buddy {
            toId = Int(sessionModel.sessionId)!
            return MsgModel.init(fromId: LoginService.shareInstance.loginInfo!.userId, toId: toId, contentStr: text, msgContentType: 1, sessionId: nil)
        }
        else {
            return MsgModel.init(fromId: LoginService.shareInstance.loginInfo!.userId, toId: toId, contentStr: text, msgContentType: 1, sessionId: sessionId)
        }
        
    }
}
