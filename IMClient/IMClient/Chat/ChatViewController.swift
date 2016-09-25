//
//  ChatViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/16.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Init
    private let myTextMsgCellId = "ChatMyTextMsgCell"
    private let buddyTextMsgCellId = "ChatBuddyTextMsgCell"
    func registerCells() {
        tableView.register(UINib(nibName: myTextMsgCellId, bundle: nil), forCellReuseIdentifier: myTextMsgCellId)
        tableView.register(UINib(nibName: buddyTextMsgCellId, bundle: nil), forCellReuseIdentifier: buddyTextMsgCellId)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITableView DataSource Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msgModel = viewModel.messages[indexPath.row]
        
        if msgModel.msgContentType == 1 && msgModel.fromUserId == LoginService.shareInstance.loginInfo?.userId {
            let cell = tableView.dequeueReusableCell(withIdentifier: myTextMsgCellId, for: indexPath)
            return cell
        }
        else if msgModel.msgContentType == 1 && msgModel.fromUserId != LoginService.shareInstance.loginInfo?.userId {
            let cell = tableView.dequeueReusableCell(withIdentifier: buddyTextMsgCellId, for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: buddyTextMsgCellId, for: indexPath)
            return cell
        }
    }
}
