//
//  SessionsTableViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/11.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class SessionsTableViewController: UITableViewController {
    
    var sessionModels: [SessionModel] = SessionModel.queryAllSession()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "会话"
        
        NotificationCenter.default.addObserver(self, selector: #selector(SessionsTableViewController.receiveNewMessage), name: NSNotification.Name(rawValue: MsgService.receiveMessageNotificationName), object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SessionsTableViewController.createNewSessionItemPressed))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method Response
    func createNewSessionItemPressed() {
        GroupService.shareInstance.createGroup(name: "groupName", memberIds: [1], groupHeadImage: nil) { (error: Error?) in
            
        }
//        GroupService.shareInstance.createGroup(name: "xxx", memberIds: [1]) { (error: NSError?) in
//            print("error: \(error)")
//        }

    }

    // MARK: - receive New Message
    func receiveNewMessage(noti: Notification)  {
        print("notification object: \(noti.object!)")
        
        sessionModels = SessionModel.queryAllSession()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sessionModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sessionCellId")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "sessionCellId")
            
            let unreadLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 30, height: 30)))
            unreadLabel.textColor = UIColor.red
            unreadLabel.tag = 999
        
            cell?.accessoryView = unreadLabel
        }
        
        let sessionModel = sessionModels[indexPath.row]
        
        cell?.textLabel?.text = "[\(sessionModel.type == .buddy ? "好友" : "群")] " + sessionModel.sessionName
        cell?.detailTextLabel?.text = sessionModel.lastMsgContent
        let unreadLabel = cell?.accessoryView as! UILabel
        unreadLabel.text = sessionModel.unreadCount > 0 ? "\(sessionModel.unreadCount)" : ""
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sessionModel = sessionModels[indexPath.row]
        
        let controller = ChatViewController()
        controller.viewModel.sessionModel = sessionModel
        
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
