//
//  BuddyInfoViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/16.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class BuddyInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isBuddyButton: UIButton!
    
    var buddyInfo: UserModel?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if LoginService.shareInstance.loginInfo != nil && buddyInfo != nil {
            if let buddyIds = LoginService.shareInstance.loginInfo {
                isBuddyButton.isSelected = buddyIds.buddyIds.contains(buddyInfo!.userId)
            }
            
            userIdLabel.text = "\(buddyInfo!.userId)"
            nameLabel.text = buddyInfo!.name
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BuddyCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Method Response
    @IBAction func isBuddyButtonPressed(sender: AnyObject) {
        
        if buddyInfo == nil {
            return
        }
        
        if isBuddyButton.isSelected {
            LoginService.shareInstance.removeBuddys([buddyInfo!.userId], complete: { [unowned self] (error: NSError?) in
                if error != nil {
                    Alert.showError(error: error!)
                }
                else {
                    self.isBuddyButton.isSelected = false
                }
            })
        }else {
            LoginService.shareInstance.addBuddys([buddyInfo!.userId], complete: { (error: NSError?) in
                if error != nil {
                    Alert.showError(error: error!)
                }
                else {
                    self.isBuddyButton.isSelected = true
                }
            })
        }
    }
    @IBAction func sendMsgButtonPressed(sender: AnyObject) {
        
    }
    
    // UITableView DataSource Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  buddyInfo != nil {
            return (self.buddyInfo!.buddyIds).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuddyCell", for: indexPath)
        
        let info = (self.buddyInfo!.buddyIds)[indexPath.row]
        cell.textLabel?.text = "userId: \(info))"
        
        return cell
    }
}
