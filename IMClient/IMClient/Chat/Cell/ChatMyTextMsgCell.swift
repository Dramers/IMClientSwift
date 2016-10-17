//
//  ChatMyTextMsgCell.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/24.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class ChatMyTextMsgCell: ChatMsgCell {

    @IBOutlet weak var textContentLabel: UILabel!
    
    override var msgModel: MsgModel? {
        didSet {
            self.textContentLabel.text = msgModel?.contentStr
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nameLabel.text = LoginService.shareInstance.loginInfo?.name
//        self.headImageView.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
