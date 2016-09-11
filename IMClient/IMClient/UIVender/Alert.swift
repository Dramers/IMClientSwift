//
//  Alert.swift
//  Health
//
//  Created by Yalin on 15/8/26.
//  Copyright (c) 2015年 Yalin. All rights reserved.
//

import UIKit

struct Alert {
    static func showErrorAlert(title: String?, message: String?) {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "确定").show()
    }
    
    static func showError(error: NSError) {
        UIAlertView(title: error.domain, message: error.localizedDescription, delegate: nil, cancelButtonTitle: "取消").show()
    }
    
    static func showAlert(title: String?, message: String?) {
        
    }
    
    static func showAlert(title: String?, message: String?, complete: (Int)?) {
        
    }
    
    static func showAlert(title: String?, message: String?, cancelButtonTitle: String?, complete: ((alert: Alert, buttonIndex: Int) -> Void)?, controller: UIViewController?, otherButtonTitles: String?...) {
        
    }
    
    static func showAlert(title: String?, message: String?, style: UIAlertViewStyle?, cancelButtonTitle: String?, complete: ((alert: Alert, buttonIndex: Int) -> Void)?, controller: UIViewController?, otherButtonTitles: String?...) {
        
    }
    
    static func showAlert(title: String?, message: String?, style: UIAlertViewStyle?, textFieldDefaultTexts: [String]?, cancelButtonTitle: String?, complete: ((alert: Alert, buttonIndex: Int) -> Void)?, controller: UIViewController?, otherButtonTitles: String?...) {
        
    }
    
    func textField(index: UInt) -> UITextField? {
        return nil
    }
}
