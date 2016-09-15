//
//  BuddyAddViewController.swift
//  IMClient
//
//  Created by LuoZhongYan on 16/9/13.
//  Copyright © 2016年 LuoZhongYan. All rights reserved.
//

import UIKit
import IMClientSDK

class BuddyAddViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchResults : [[String : AnyObject]] = []

    var searchController: UISearchController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.delegate = self
        searchController?.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        self.tableView.tableHeaderView = searchController?.searchBar
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BuddyAddCell")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuddyAddCell", forIndexPath: indexPath)

        // Configure the cell...
        var info = searchResults[indexPath.row]
        cell.textLabel?.text = "\(info["name"] as! String)  userId: \(info["userId"] as! Int)  username: \(info["username"] as! String)"

        return cell
    }
 

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 添加好友
        var info = searchResults[indexPath.row]
        LoginService.shareInstance.addBuddys([info["userId"] as! Int]) { (error: NSError?) in
            if error != nil {
                Alert.showError(error!)
            }
        }
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        LoginService.shareInstance.searchUsers(searchBar.text!) { [unowned self] (results: [[String : AnyObject]]?, error: NSError?) in
            
            if error == nil {
                self.searchResults = results!
                self.tableView.reloadData()
            }
            else {
                Alert.showError(error!)
            }
        }
    }
}
