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
    
    var buddyInfo: [String: AnyObject]?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if LoginService.shareInstance.loginInfo != nil && buddyInfo != nil {
            if let buddyIds = LoginService.shareInstance.loginInfo {
                isBuddyButton.selected = buddyIds.buddyIds.contains(buddyInfo!["userId"] as! Int)
            }
            
            userIdLabel.text = "\(buddyInfo!["userId"] as! Int)"
            usernameLabel.text = buddyInfo?["username"] as? String
            nameLabel.text = buddyInfo?["name"] as? String
        }
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BuddyCell")
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
        
        if isBuddyButton.selected {
            LoginService.shareInstance.removeBuddys([buddyInfo!["userId"] as! Int], complete: { [unowned self] (error: NSError?) in
                if error != nil {
                    Alert.showError(error!)
                }
                else {
                    self.isBuddyButton.selected = false
                }
            })
        }else {
            LoginService.shareInstance.addBuddys([buddyInfo!["userId"] as! Int], complete: { (error: NSError?) in
                if error != nil {
                    Alert.showError(error!)
                }
                else {
                    self.isBuddyButton.selected = true
                }
            })
        }
    }
    
    // UITableView DataSource Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  buddyInfo != nil {
            return (self.buddyInfo!["buddyIds"] as! [Int]).count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuddyCell", forIndexPath: indexPath)
        
        let info = (self.buddyInfo!["buddyIds"] as! [Int])[indexPath.row]
        cell.textLabel?.text = "userId: \(info))"
        
        return cell
    }
}
