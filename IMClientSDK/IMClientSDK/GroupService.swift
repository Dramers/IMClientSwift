//
//  GroupService.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/11/9.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

open class GroupService: NSObject {
    
    open static let shareInstance = GroupService()
    
    var tasks: [String : Any] = [:]
    
    func listenEvent() {
        MsgService.shareInstance.socket?.on("createGroup", callback: { (info: [Any], ack: SocketAckEmitter) in
            
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        MsgService.shareInstance.socket?.on("queryGroupList", callback: { (info: [Any], ack: SocketAckEmitter) in
            if let (data , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? ([GroupModel]?, Error?) -> Void {
                    
                    var groupList: [GroupModel]? = nil
                    if err == nil && data != nil {
                        
                        if let groupInfoList = data as? [[String : Any]] {
                            groupList = []
                            
                            for groupInfo in groupInfoList {
                                groupList?.append(GroupModel(info: groupInfo))
                            }
                        }
                    }
                    
                    complete(groupList,err)
                }
            }
        })
        
        MsgService.shareInstance.socket?.on("addGroupMembers", callback: { (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        MsgService.shareInstance.socket?.on("kickGroupMembers", callback: { (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        MsgService.shareInstance.socket?.on("updateGroupInfo", callback: { (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        MsgService.shareInstance.socket?.on("deleteGroup", callback: { (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
    }
    
    open func createGroup(name: String, memberIds: [Int], groupHeadImage: String?, complete: @escaping (Error?) -> Void) {
        
        send(data: [
            "groupName" : name,
            "memberIds" : memberIds,
            "groupHeadImage" : groupHeadImage == nil ? "" : groupHeadImage!,
            ], eventName: "createGroup", complete: complete)
    }
    
    open func queryGroupList(complete: @escaping ([GroupModel]?, Error?) -> Void) {
        
        send(data: nil, eventName: "queryGroupList", complete: complete)
    }
    
    open func addGroupMembers(groupId: String, memberIds: [Int], complete: @escaping (Error?) -> Void) {
        
        send(data: ["groupId" : groupId, "memberIds" : memberIds], eventName: "addGroupMembers", complete: complete)
    }
    
    open func kickGroupMembers(groupId: String, memberIds: [Int], complete: @escaping (Error?) -> Void) {
        send(data: ["groupId" : groupId, "memberIds" : memberIds], eventName: "kickGroupMembers", complete: complete)
    }
    
    open func updateGroupInfo(groupId: String, groupName: String, groupHeadImage: String?, creator: Int, complete: @escaping (Error?) -> Void) {
        send(data: [
            "groupId" : groupId,
            "groupName" : groupName,
            "groupHeadImage" : groupHeadImage == nil ? groupHeadImage! : "",
            "creator" : creator
            ], eventName: "updateGroupInfo", complete: complete)
    }
    
    open func deleteGroup(groupId: String, complete: @escaping (Error?) -> Void) {
        send(data: ["groupId" : groupId], eventName: "deleteGroup", complete: complete)
    }
    
    func send(data: [String : Any]?, eventName: String, complete: Any) {
        let taskId = generateTaskId()
        
        var info = data
        
        if info == nil {
            info = [:]
        }
        
        info!["taskId"] = taskId
        info!["userId"] = LoginService.shareInstance.loginInfo!.userId
        MsgService.shareInstance.socket?.emit(eventName, with: [info!])
        tasks[taskId] = complete
    }
    
    func praseResponseData(info: [Any]) -> (Any?, Error?, Any)? {
        
        if let responseInfo = info.first as? [String : Any] {
            
            if let taskId = responseInfo["taskId"] as? String {
                
                
                if let complete = self.tasks[taskId] {
                    
                    self.tasks.removeValue(forKey: taskId)
                    
                    if let code = responseInfo["code"] as? Int
                    {
                        if code == 0 {
                            return (responseInfo["result"], nil, complete)
                        }
                        else {
                            let msg = responseInfo["result"] as! String
                            let err = NSError(domain: "GroupService Server Error", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
                            return (nil, err, complete)
                        }
                    }
                }
                
                
            }
            
            
        }
        
        return nil
    }
    
    func generateTaskId() -> String {
        let taskCount = tasks.keys.count
        let taskId = "\(taskCount+1)"
        tasks[taskId] = taskId
        return taskId
    }
}
