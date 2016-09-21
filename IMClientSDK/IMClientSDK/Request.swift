//
//  Request.swift
//  IMClientSDK
//
//  Created by LuoZhongYan on 16/9/8.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

class Request: NSObject {
    
    class func sendJsonRequest(_ urlString: String, jsonInfo info: [String: Any], complete: @escaping (AnyObject?, NSError?) -> Void) {
        
        do {
            let bodyJsonData = try JSONSerialization.data(withJSONObject: info, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            print("send json Data: \(NSString (data: bodyJsonData, encoding: String.Encoding.utf8.rawValue))");
            
            if let url = URL(string: urlString) {
//                let request = NSMutableURLRequest(url: url)
//                request.httpBody = bodyJsonData
//                request.httpMethod = "POST"
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                var request = URLRequest(url: url)
                request.httpBody = bodyJsonData
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                            DispatchQueue.main.async(execute: {
                                complete(nil, NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)]))
                            });
                            return
                        }
                    }
                    
                    var err: NSError? = error as NSError?
                    var info :AnyObject? = nil
                    if err == nil {
                        do {
                            let bodyJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            print("receive JSON String: \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))")
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
                                info = bodyJson as AnyObject?
                            }
                        }
                        catch let error as NSError {
                            err = error
                        }
                    }
                    
                    
                    DispatchQueue.main.async(execute: {
                        complete(info, err as NSError?)
                    });
                })
                task.resume()
            }
            else {
                DispatchQueue.main.async(execute: { 
                    complete(nil, NSError(domain: "Request", code: 10001, userInfo: [NSLocalizedDescriptionKey : "bad URL"]))
                })
                
            }
            
        }
        catch let error as NSError {
            DispatchQueue.main.async(execute: {
                complete(nil, error)
            });
        }
    }
}
