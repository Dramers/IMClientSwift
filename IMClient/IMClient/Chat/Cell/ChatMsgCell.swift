//
//  ChatMsgCell.swift
//  IMClient
//
//  Created by Yalin on 2016/10/17.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

fileprivate let myTextMsgCellId = "ChatMyTextMsgCell"
fileprivate let buddyTextMsgCellId = "ChatBuddyTextMsgCell"

class ChatMsgCell: UITableViewCell {
    
    var msgModel: MsgModel?
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    class func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName: myTextMsgCellId, bundle: nil), forCellReuseIdentifier: myTextMsgCellId)
        tableView.register(UINib(nibName: buddyTextMsgCellId, bundle: nil), forCellReuseIdentifier: buddyTextMsgCellId)
    }
    
    class func create(msgModel: MsgModel, tableView: UITableView, indexPath: IndexPath) -> ChatMsgCell? {
        
        if let cellId = cellId(fromUserId: msgModel.fromUserId, msgContentType: msgModel.msgContentType) {
            return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ChatMsgCell
        }
        
        return nil
    }
    
    class func cellId(fromUserId: Int, msgContentType: Int) -> String? {
        if fromUserId == LoginService.shareInstance.loginInfo?.userId {
            // 自己
            if msgContentType == 1 {
                return myTextMsgCellId
            }
            
        }
        else {
            // 别人
            if msgContentType == 1 {
                return buddyTextMsgCellId
            }
        }
        return nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
