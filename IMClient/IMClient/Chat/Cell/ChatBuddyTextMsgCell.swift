//
//  ChatBuddyTextMsgCell.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/24.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class ChatBuddyTextMsgCell: ChatMsgCell {

    @IBOutlet weak var textContentLabel: UILabel!
    
    override var msgModel: MsgModel? {
        didSet {
            self.textContentLabel.text = msgModel?.contentStr
            
            LoginService.shareInstance.queryUserInfo(userId: msgModel!.fromUserId) { [unowned self] (userModel: UserModel?, error: NSError?) in
                self.nameLabel.text = LoginService.shareInstance.loginInfo?.name
            }
            
        }
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
