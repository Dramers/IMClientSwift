//
//  GroupInfoViewController.swift
//  IMClient
//
//  Created by Yalin on 2016/11/16.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class GroupInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var viewModel: GroupModel?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = viewModel?.groupName
        
        self.tableView.register(UINib(nibName: "GroupMemberCell", bundle: nil), forCellReuseIdentifier: "GroupMemberCell")
        
        let addMemberItem = UIBarButtonItem(title: "加人", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GroupInfoViewController.selectBuddyItemPressed))
        let updateTitleItem = UIBarButtonItem(title: "改名", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GroupInfoViewController.updateGroupInfoItemPressed))
        
        self.navigationItem.rightBarButtonItems = [updateTitleItem, addMemberItem]
            // UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(GroupInfoViewController.selectBuddyItemPressed))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshGroupDatas() {
        
    }
    
    // MARK: - Response Method
    func updateGroupInfoItemPressed() {
        
    }
    
    func selectBuddyItemPressed() {
        let controller = BuddySelectController()
        controller.complete = { (users: [UserModel]) in
            
            var memberIds: [Int] = []
            for user in users {
                memberIds.append(user.userId)
            }
            
            if memberIds.count > 0 {
                GroupService.shareInstance.addGroupMembers(groupId: self.viewModel!.groupId, memberIds: memberIds, complete: { [unowned self] (error: Error?) in
                    if error == nil {
                        self.viewModel?.memberIds.append(contentsOf: memberIds)
                        self.tableView.reloadData()
                    }
                    else {
                        Alert.showError(error: error as! NSError)
                    }
                })
            }
            
            
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func exitGroupButtonPressed(_ sender: Any) {
        
        GroupService.shareInstance.deleteGroup(groupId: viewModel!.groupId) { [unowned self] (error: Error?) in
            
            if error == nil {
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
            else {
                Alert.showError(error: error as! NSError)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.memberIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath)
        
        let userId = viewModel!.memberIds[indexPath.row]
        cell.textLabel?.text = ""
        LoginService.shareInstance.queryUserInfo(userId: userId) { (user: UserModel?, error: NSError?) in
            if error == nil {
                cell.textLabel?.text = user?.name
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let userId = self.viewModel!.memberIds[indexPath.row]
        if  editingStyle == .delete {
            if let index = self.viewModel?.memberIds.index(where: { (id: Int) -> Bool in
                return userId == id
            }) {
                
                GroupService.shareInstance.kickGroupMembers(groupId: self.viewModel!.groupId, memberIds: [userId], complete: { (error: Error?) in
                    
                    if error == nil {
                        self.viewModel?.memberIds.remove(at: index)
                        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                    }
                    else {
                        Alert.showError(error: error as! NSError)
                    }
                })
                
                
            }
        }
    }
}
