//
//  GroupTableViewController.swift
//  IMClient
//
//  Created by Yalin on 2016/11/12.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class GroupTableViewController: UITableViewController {
    
    var datas: [GroupModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "群组"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(GroupTableViewController.createGroupItemPressed))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshControl?.addTarget(self, action: #selector(GroupTableViewController.refreshGroupDatas), for: UIControlEvents.valueChanged)
        
        self.tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        
        refreshGroupDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method Response
    func createGroupItemPressed() {
        
        Alert.showAlert(title: "请输入要创建的群组名称", message: nil, style: UIAlertViewStyle.plainTextInput, cancelButtonTitle: "取消", complete: { [unowned self] (alert: Alert, buttonIndex: Int) in
            
                if buttonIndex != 0 {
                    let textField = alert.textField(index: 0)!
                    
                    let groupName = textField.text == nil ? "" : textField.text!
                    
                    GroupService.shareInstance.createGroup(name: groupName, memberIds: [1], groupHeadImage: nil) { (error: Error?) in
                        
                        if error == nil {
                            self.refreshGroupDatas()
                        }
                    }
                }
            
            }, controller: self, otherButtonTitles: "确定");
    }
    
    func refreshGroupDatas() {
        GroupService.shareInstance.queryGroupList { [unowned self] (list: [GroupModel]?, err: Error?) in
            if err == nil && list != nil {
                self.datas = list!
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)

        let groupModel = datas[indexPath.row]
        
        cell.textLabel?.text = groupModel.groupName

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
