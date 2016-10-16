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
}
