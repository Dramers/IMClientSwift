//
//  RegisterAccountViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/11.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class RegisterAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
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
    
    
    @IBAction func commitButtonPressed(sender: AnyObject) {
        LoginService.shareInstance.register(usernameTextField.text!, password: passwordTextField.text!, name: usernameTextField.text!) { [unowned self] (info: LoginInfo?, error: NSError?) in
            
            if error != nil {
                Alert.showError(error!)
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    @IBAction func bgPressed(sender: AnyObject) {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        checkPasswordTextField.resignFirstResponder()
    }
}
