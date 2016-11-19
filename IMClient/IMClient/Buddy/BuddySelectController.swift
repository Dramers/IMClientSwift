//
//  BuddySelectController.swift
//  IMClient
//
//  Created by Yalin on 2016/11/19.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class BuddySelectController: UITableViewController {
    
    var buddys: [UserModel] = []
    var selectedBuddys: [UserModel] = []
    
    var complete: (([UserModel]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "选取好友"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(BuddySelectController.selectBuddyItemPressed))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BuddyCell")
        
        refreshDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Refresh Datas
    func refreshDatas()  {
        LoginService.shareInstance.queryBuddys { [unowned self] (queryBuddys: [UserModel]?, error: NSError?) in
            if queryBuddys != nil {
                self.buddys = queryBuddys!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Response Method
    func selectBuddyItemPressed() {
        complete?(self.selectedBuddys)
        let _ = self.navigationController?.popViewController(animated: true)
        
    }

    // MARK: - Table view data source

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buddys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuddyCell", for: indexPath)
        
        // Configure the cell...
        let info = buddys[indexPath.row]
        cell.textLabel?.text = "\(info.name)  userId: \(info.userId)"
        if selectedBuddys.contains(where: { (userModel: UserModel) -> Bool in
            return userModel.userId == info.userId
        }) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let buddyInfo = buddys[indexPath.row]
        
        if let index = selectedBuddys.index(where: { (userModel: UserModel) -> Bool in
            return userModel.userId == buddyInfo.userId
        }){
            // 存在
            selectedBuddys.remove(at: index)
        }
        else {
            // 不存在
            selectedBuddys.append(buddyInfo)
        }
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
