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
    
    open static let groupDeleteNotification = "kGroupDeleteNotification"
    open static let groupInfoUpdateNotification = "kGroupInfoUpdateNotification"
    open static let groupMembersDeleteNotification = "kGroupMembersDeleteNotification"
    open static let groupMembersAddNotification = "kGroupMembersAddNotification"
    open static let createGroupNotification = "kCreateGroupNotification"
    
    
    
    var tasks: [String : Any] = [:]
    
    func listenEvent(socket: SocketIOClient) {
        socket.off("createGroup")
        socket.on("createGroup", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        socket.off("queryGroupList")
        socket.on("queryGroupList", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
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
        
        socket.off("addGroupMembers")
        socket.on("addGroupMembers", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        socket.off("kickGroupMembers")
        socket.on("kickGroupMembers", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        socket.off("updateGroupInfo")
        socket.on("updateGroupInfo", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                }
            }
        })
        
        socket.off("deleteGroup")
        socket.on("deleteGroup", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let (_ , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (Error?) -> Void {
                    complete(err)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: GroupService.groupDeleteNotification), object: nil)
                }
            }
        })
        
        socket.off("queryGroupInfo")
        socket.on("queryGroupInfo", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            
            if let (data , err, callback) = self.praseResponseData(info: info) {
                if let complete = callback as? (GroupModel?, Error?) -> Void {
                    
                    var groupModel: GroupModel? = nil
                    if err == nil && data != nil {
                        
                        if let groupInfo = data as? [String : Any] {
                            groupModel = GroupModel(info: groupInfo)
                        }
                    }
                    
                    complete(groupModel,err)
                }
            }
        })
        
        socket.off("deleteGroupNoti")
        socket.on("deleteGroupNoti", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            
            if let data = info.first as? [String : Any] {
                self.deleteGroupNotiReceive(info: data)
            }
        })
        
        socket.off("createGroupNoti")
        socket.on("createGroupNoti", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let data = info.first as? [String : Any] {
                self.createGroupNotiReceive(info: data)
            }
        })
        
        socket.off("groupMembersAddNoti")
        socket.on("groupMembersAddNoti", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let data = info.first as? [String : Any] {
                self.groupMembersAddNotiReceive(info: data)
            }
        })
        
        socket.off("groupMembersDelNoti")
        socket.on("groupMembersDelNoti", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let data = info.first as? [String : Any] {
                self.groupMembersDelNotiReceive(info: data)
            }
        })
        
        socket.off("groupInfoUpdateNoti")
        socket.on("groupInfoUpdateNoti", callback: { [unowned self] (info: [Any], ack: SocketAckEmitter) in
            if let data = info.first as? [String : Any] {
                self.groupInfoUpdateNotiReceive(info: data)
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
            "groupHeadImage" : groupHeadImage == nil ? "" : groupHeadImage!,
            "creator" : creator
            ], eventName: "updateGroupInfo", complete: complete)
    }
    
    open func queryGroupInfo(groupId: String, complete: @escaping (GroupModel?, Error?) -> Void) {
        send(data: ["groupId" : groupId], eventName: "queryGroupInfo", complete: complete)
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

// MARK: - Group Noti Message Deal
extension GroupService {
    
    func deleteGroupNotiReceive(info: [String : Any]) {
        
        if let groupId = info["groupId"] {
            NotificationCenter.default.post(name: NSNotification.Name(GroupService.groupDeleteNotification), object: groupId)
        }
    }
    
    func createGroupNotiReceive(info: [String : Any]) {
        if let _ = info["groupId"] {
            NotificationCenter.default.post(name: NSNotification.Name(GroupService.createGroupNotification), object: GroupModel(info: info))
        }
    }
    
    func groupMembersAddNotiReceive(info: [String : Any]) {
        if let groupId = info["groupId"] {
            NotificationCenter.default.post(name: NSNotification.Name(GroupService.groupMembersAddNotification), object: groupId)
        }
    }
    
    func groupMembersDelNotiReceive(info: [String : Any]) {
        if let groupId = info["groupId"] {
            NotificationCenter.default.post(name: NSNotification.Name(GroupService.groupMembersDeleteNotification), object: groupId)
        }
    }
    
    func groupInfoUpdateNotiReceive(info: [String : Any]) {
        if let _ = info["groupId"] {
            NotificationCenter.default.post(name: NSNotification.Name(GroupService.groupInfoUpdateNotification), object: GroupModel(info: info))
        }
    }
}
