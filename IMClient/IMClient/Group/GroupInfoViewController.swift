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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
