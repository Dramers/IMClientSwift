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
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var toolBarViewBottomContrains: NSLayoutConstraint!
    
    var viewModel = ChatViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChatMsgCell.registerCell(tableView: tableView)
        
        viewModel.reloadMsgs()
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.showKeyboardNoti(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.hideKeyboardNoti(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.showKeyboardNoti(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.receiveNewMessage), name: NSNotification.Name(rawValue: MsgService.receiveMessageNotificationName), object: nil)
    }
    
    func keyboardChange(noti: Notification) {
        
        let userInfo = noti.userInfo!
        if let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = value.cgRectValue
            self.toolBarViewBottomContrains.constant = keyboardRect.size.height
        }
    }
    
    func showKeyboardNoti(noti: Notification) {
        let userInfo = noti.userInfo!
        if let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = value.cgRectValue
            self.toolBarViewBottomContrains.constant = keyboardRect.size.height
        }
    }
    
    func hideKeyboardNoti(noti: Notification) {
        self.toolBarViewBottomContrains.constant = 0
    }
    
    // MARK: - receive New Message
    func receiveNewMessage(noti: Notification)  {
        print("notification object: \(noti.object!)")
        if let session = noti.userInfo?["session"] as? SessionModel {
            if session.sessionId == self.viewModel.sessionModel!.sessionId {
                
                self.viewModel.reloadCurrentMsgs()
                self.tableView.reloadData()
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Init

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Response Method
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        
        MsgService.shareInstance.sendMessage(self.viewModel.textMsg(text: self.textView.text)) { (error: NSError?) in
            
        }
        
        self.textView.text = ""
        self.textView.resignFirstResponder()
    }

    // MARK: - UITableView DataSource Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msgModel = viewModel.messages[indexPath.row]
        
        let cell = ChatMsgCell.create(msgModel: msgModel, tableView: tableView, indexPath: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ChatViewController: UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let nsString = textView.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: text)
        if newString != "" && newString != nil {
            sendButton.isEnabled = true
        }
        else {
            sendButton.isEnabled = false
        }
        
        return true
    }
}
