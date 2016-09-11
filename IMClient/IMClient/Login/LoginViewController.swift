//
//  LoginViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func loginButtonPressed(sender: AnyObject) {
        LoginService.shareInstance.login(userNameTextField.text!, password: passwordTextField.text!) { (info: LoginInfo?, error: NSError?) in
            if error == nil {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.turnToMainController()
            }
            else {
                Alert.showError(error!)
            }
        }
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        self.navigationController?.pushViewController(RegisterAccountViewController(), animated: true)
    }
    
    @IBAction func bgPressed(sender: AnyObject) {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
