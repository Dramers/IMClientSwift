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
        _ = Alert.showAlert(title: title, message: message)
    }
    
    static func showError(error: NSError) {
        _ = Alert.showErrorAlert(title: error.domain, message: error.localizedDescription)
    }
    
    @discardableResult
    static func showAlert(title: String?, message: String?)  -> Alert {
        return Alert.showAlert(title: title, message: message, complete: nil)
    }
    
    @discardableResult
    static func showAlert(title: String?, message: String?, complete: ((_ alert: Alert, _ buttonIndex: Int) -> Void)?) -> Alert {
        return Alert.showAlert(title: title, message: message, cancelButtonTitle: "确定", complete: complete, controller: nil, otherButtonTitles: nil)
    }
    
    @discardableResult
    static func showAlert(title: String?, message: String?, cancelButtonTitle: String?, complete: ((_ alert: Alert, _ buttonIndex: Int) -> Void)?, controller: UIViewController?, otherButtonTitles: String?...)  -> Alert {
        
        var buttonTitles: [String]? = nil
        
        if otherButtonTitles.count > 0 {
            buttonTitles = []
            for title in otherButtonTitles {
                if title != nil {
                    buttonTitles?.append(title!)
                }
            }
        }
        
        return Alert(title: title, message: message, style: .default, cancelButtonTitle: cancelButtonTitle, complete: complete, controller: controller, textFieldDefaultTexts: nil, otherButtonTitles: buttonTitles)
    }
    
    @discardableResult
    static func showAlert(title: String?, message: String?, style: UIAlertViewStyle?, cancelButtonTitle: String?, complete: ((_ alert: Alert, _ buttonIndex: Int) -> Void)?, controller: UIViewController?, otherButtonTitles: String?...)  -> Alert {
        
        var buttonTitles: [String]? = nil
        
        if otherButtonTitles.count > 0 {
            buttonTitles = []
            for title in otherButtonTitles {
                if title != nil {
                    buttonTitles?.append(title!)
                }
            }
        }
        
        return Alert(title: title, message: message, style: style == nil ? .default : style!, cancelButtonTitle: cancelButtonTitle, complete: complete, controller: controller, textFieldDefaultTexts: nil, otherButtonTitles: buttonTitles)
    }
    
    @discardableResult
    static func showAlert(title: String?, message: String?, style: UIAlertViewStyle?, textFieldDefaultTexts: [String]?, cancelButtonTitle: String?, complete: ((_ alert: Alert, _ buttonIndex: Int) -> Void)?, controller: UIViewController?, otherButtonTitles: String?...) -> Alert {
        
        var buttonTitles: [String]? = nil
        
        if otherButtonTitles.count > 0 {
            buttonTitles = []
            for title in otherButtonTitles {
                if title != nil {
                    buttonTitles?.append(title!)
                }
            }
        }
        
        let alert = Alert(title: title, message: message, style: style == nil ? .default : style!, cancelButtonTitle: cancelButtonTitle, complete: complete, controller: controller, textFieldDefaultTexts: textFieldDefaultTexts, otherButtonTitles: buttonTitles)
        
        return alert
    }
    
    func textField(index: Int) -> UITextField? {
        if alert.textFields != nil && index < alert.textFields!.count {
            return alert.textFields![index]
        }
        return nil
    }
    
    var alert: UIAlertController
    
    init(title: String?, message: String?, style: UIAlertViewStyle, cancelButtonTitle: String?, complete:((_ alert: Alert, _ buttonIndex: Int) -> Void)?, controller: UIViewController?, textFieldDefaultTexts: [String]?, otherButtonTitles: [String]?) {
        
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        setAlert(alert: alert, title: title, message: message, style: style, cancelButtonTitle: cancelButtonTitle, complete: complete, controller: controller, textFieldDefaultTexts: textFieldDefaultTexts, otherButtonTitles: otherButtonTitles)
    }
    
    func setAlert(alert: UIAlertController, title: String?, message: String?, style: UIAlertViewStyle, cancelButtonTitle: String?, complete:((_ alert: Alert, _ buttonIndex: Int) -> Void)?, controller: UIViewController?, textFieldDefaultTexts: [String]?, otherButtonTitles: [String]?) {
        if cancelButtonTitle != nil {
            let cancelAction = UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
                complete?(self, 0)
            })
            alert.addAction(cancelAction)
        }
        
        if otherButtonTitles != nil {
            for title in otherButtonTitles! {
                let action = UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                    complete?(self, otherButtonTitles!.index(of: title)! + 1)
                })
                alert.addAction(action)
            }
        }
        
        setStyle(alert: alert, style: style, textFieldDefaultTexts: textFieldDefaultTexts)
        
        if controller != nil {
            controller?.present(alert, animated: true, completion: nil)
        }
        else {
            if let window = UIApplication.shared.delegate?.window {
                if let appRootController = window!.rootViewController {
                    appRootController.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func setStyle(alert: UIAlertController, style: UIAlertViewStyle, textFieldDefaultTexts: [String]?) {
        
        switch style {
        case .plainTextInput:
            alert.addTextField(configurationHandler: { (textField: UITextField) in
                if let defaultText = textFieldDefaultTexts?.first {
                    textField.text = defaultText
                }
            })
        case .secureTextInput:
            alert.addTextField(configurationHandler: { (textField: UITextField) in
                if let defaultText = textFieldDefaultTexts?.first {
                    textField.text = defaultText
                }
                textField.isSecureTextEntry = true
            })
        case .loginAndPasswordInput:
            alert.addTextField(configurationHandler: { (textField: UITextField) in
                
                textField.placeholder = "username";
                if let defaultText = textFieldDefaultTexts?.first {
                    textField.text = defaultText
                }
            })
            alert.addTextField(configurationHandler: { (textField: UITextField) in
                textField.placeholder = "password";
                if let defaultText = textFieldDefaultTexts?[1] {
                    textField.text = defaultText
                }
            })
        default:
            break
        }
    }
}
