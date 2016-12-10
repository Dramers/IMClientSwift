//
//  FileService.swift
//  IMClientSDK
//
//  Created by Yalin on 2016/12/3.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

public protocol FileServiceDelegate {
    func progress(filePath: String, progress: Float)
}

open class FileService: NSObject {
    
    open static let shareInstance = FileService()

    open func upload(filePath: String, delegate: FileServiceDelegate, complete: (String?, NSError?) -> Void) {
        
        
//        guard let url = URL(fileURLWithPath: filePath) else {
//            complete(nil, NSError(domain: "FileService", code: 10001, userInfo: [NSLocalizedDescriptionKey : "Bad file url: \(filePath)"]))
//            return
//        }
//        
//        URLRequest(url: <#T##URL#>)
//        
//        URLSession.shared.uploadTask(with: <#T##URLRequest#>, fromFile: <#T##URL#>)
    }
}
