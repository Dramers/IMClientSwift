//
//  MyInfoViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/11.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class MyInfoViewController: UIViewController {

    @IBOutlet weak var myNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我的"
        
        self.myNameLabel.text = LoginService.shareInstance.loginInfo?.name
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

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        LoginService.shareInstance.logout()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.turnToLoginController()
    }
}
