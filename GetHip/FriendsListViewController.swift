//
//  FriendsListViewController.swift
//  GetHip
//
//  Created by Okechi on 1/5/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class FriendsListViewController: UITableViewController/*PFQueryTableViewController*/ {
    //var manager = FriendDataSource()
    var friends = []
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBAction func dismissFriendView(sender: UIBarButtonItem) {
        
        self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    func setData(frnds:[FriendData]){
        self.friends = frnds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.friends = manager.getFriends()
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "refreshTableView", object: nil)
        //debug statements
        
        
    }
    
    /*func refreshTable(notification: NSNotification){
        self.friends = manager.getFriends()
        self.table.reloadData()
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friend = self.friends[indexPath.row] as? FriendData
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? FriendsCell
    
        //sets display name of friend (print for debugging purposes)
        cell!.friendName.text = friend!.displayName
        println(friend!.displayName)
        
        //sets profile image of current cell
        //checks if friend user has a profile image or not
        if friend?.profileImg == nil {
            cell!.proImage.backgroundColor = UIColor.grayColor()
        }
        else{
        
        }
        
        //rounds uiimage and configures UIImageView
        //cell!.proImage.layer.borderWidth = 3.0
        //cell!.proImage.clipsToBounds = true
        cell!.proImage.layer.cornerRadius = cell!.proImage.frame.size.width/2
        
        //cell!.proImage.layer.borderColor = UIColor.whiteColor().CGColor
        //cell!.proImage.layer.masksToBounds = true
        
        
        return cell!
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.table.setEditing(editing, animated: true)
        if editing{
            
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            //delete friend from users friend array, parse, and tableView
            println("delete")
        default:
            return
        
        }
    }

}
