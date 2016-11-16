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
    
    var searchResults : [UserModel] = []

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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BuddyAddCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController?.isActive = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuddyAddCell", for: indexPath)
        
        // Configure the cell...
        let info = searchResults[indexPath.row]
        cell.textLabel?.text = "\(info.name)  userId: \(info.userId)"
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 添加好友
        self.searchController?.isActive = false
        
        let infoController = BuddyInfoViewController()
        infoController.buddyInfo = searchResults[indexPath.row]
        self.navigationController?.pushViewController(infoController, animated: true)
        
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        LoginService.shareInstance.searchUsers(searchBar.text!) { [unowned self] (results: [UserModel]?, error: NSError?) in
            
            if error == nil {
                self.searchResults = results!
                self.tableView.reloadData()
            }
            else {
                Alert.showError(error: error!)
            }
        }
    }
}
