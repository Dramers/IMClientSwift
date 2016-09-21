//
//  MainTabBarViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/11.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initVieControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initVieControllers() {
        // Session
        let sessionController = navigationControoler(controller: SessionsTableViewController(), title: "会话", image: nil, selectedImage: nil)
        
        // Buddy
        let buddyController = navigationControoler(controller: BuddyTableViewController(), title: "好友", image: nil, selectedImage: nil)
        
        // My
        let myController = navigationControoler(controller: MyInfoViewController(), title: "我的", image: nil, selectedImage: nil)
        
        self.viewControllers = [sessionController, buddyController, myController]
    }
    
    func navigationControoler(controller: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isTranslucent = false
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
//        navigationController.title = title
        return navigationController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
