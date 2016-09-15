//
//  Request.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

class Request: NSObject {
    
    class func sendJsonRequest(urlString: String, info: [String: AnyObject], complete: (AnyObject?, NSError?) -> Void) {
        
        do {
            let bodyJsonData = try NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted)
            
            
            print("send json Data: \(NSString (data: bodyJsonData, encoding: NSUTF8StringEncoding))");
            
            if let url = NSURL(string: urlString) {
                let request = NSMutableURLRequest(URL: url)
                request.HTTPBody = bodyJsonData
                request.HTTPMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                    
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                            dispatch_async(dispatch_get_main_queue(), {
                                complete(nil, NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)]))
                            });
                            return
                        }
                    }
                    
                    var err = error
                    var info :AnyObject? = nil
                    if err == nil {
                        do {
                            let bodyJson = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                            
                            print("receive JSON String: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
                            if let code = bodyJson["code"] as? Int {
                                
                                if code > 0 {
                                    let msg = bodyJson["result"] as! String;
                                    err = NSError(domain: "Request", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
                                }
                                else {
                                    info = bodyJson["result"]
                                }
                            }
                            else {
                                info = bodyJson
                            }
                        }
                        catch let error as NSError {
                            err = error
                        }
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        complete(info, err)
                    });
                })
                task.resume()
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { 
                    complete(nil, NSError(domain: "Request", code: 10001, userInfo: [NSLocalizedDescriptionKey : "bad URL"]))
                })
                
            }
            
        }
        catch let error as NSError {
            dispatch_async(dispatch_get_main_queue(), {
                complete(nil, error)
            });
        }
    }
}
