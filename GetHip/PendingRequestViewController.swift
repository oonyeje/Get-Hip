//
//  PendingRequestViewController.swift
//  GetHip
//
//  Created by Okechi on 1/29/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class PendingRequestViewController: UITableViewController {
    @IBOutlet var table:UITableView!
    
    var requests = []
    var party: PartyServiceManager!
    
    @IBAction func didAcceptFriend(sender: AnyObject?){
        var path:NSIndexPath = self.table.indexPathForCell(sender?.superview!!.superview as! PendingFriendCell)!
        var cell: PendingFriendCell! = self.table.cellForRowAtIndexPath(path) as! PendingFriendCell
        
        var query: PFQuery! = PFQuery(className: "FriendRequest")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("RequestStatus", equalTo: "pending")
        query.whereKey("inRealtionTo", equalTo: cell.friendName.text!)
        query.includeKey("OtherUser")
        
        dispatch_async(dispatch_get_main_queue(), {
            query.getFirstObjectInBackgroundWithBlock({
                (object:PFObject?, error: NSError?) -> Void in
                
                if(error == nil){
                    object!.setObject("accepted", forKey: "RequestStatus")
                    object!.save()
                    PFUser.currentUser()?.relationForKey("FriendRequest").addObject(object!)
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        PFUser.currentUser()!.saveInBackgroundWithBlock({
                            (succeeded, error) -> Void in
                            
                            if(succeeded){
                                
                            }
                            
                        })
                        
                    })
                    
                    //change requestStatus of other user who initiated request
                    var otherQuery: PFQuery! = PFQuery(className: "FriendRequest")
                    println(object!.objectForKey("OtherUser")!.objectForKey("username")!)
                    otherQuery.whereKey("username", equalTo: object!.objectForKey("OtherUser")!.objectForKey("username")!)
                    otherQuery.whereKey("inRealtionTo", equalTo: PFUser.currentUser()?.username as String!)
                    otherQuery.whereKey("RequestStatus", equalTo: "Awaiting Response")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        otherQuery.getFirstObjectInBackgroundWithBlock({
                            (object, error) -> Void in
                            
                            if(error == nil){
                                object!.setObject("accepted", forKey: "RequestStatus")
                                object!.save()
                                
                            
                                
                            }
                        })
                    })
                    
                    var params = NSMutableDictionary()
                    params.setObject(object!.objectForKey("OtherUser")!.objectForKey("username") as! String!, forKey: "otherUser")
                    
                    PFCloud.callFunctionInBackground("alertAcceptedFriend", withParameters: params as [NSObject : AnyObject])
                    
                }
            })
        })
        
        cell.proImg.hidden = true
        cell.acceptButton.hidden = true
        cell.denyButton.hidden = true
        var tempString = cell.friendName.text!
        cell.friendName.text = "You added " + tempString + "!!"
        //self.table.reloadData()
        
    }
    
    @IBAction func didRejectFriend(sender: AnyObject?){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friend Requests"
        self.table.dataSource = self
        self.table.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setData(data: [FriendData], party: PartyServiceManager){
        self.requests = data
        self.party = party
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.requests.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let pending = self.requests[indexPath.row] as? FriendData
            let cell = self.table.dequeueReusableCellWithIdentifier("PendingCell", forIndexPath: indexPath) as? PendingFriendCell
            
            //sets display name of friend (print for debugging purposes)
            cell!.friendName.text = pending!.displayName
            //println(friend!.displayName)
            
            //sets profile image of current cell
            //checks if friend user has a profile image or not
            if pending?.profileImg == nil {
                cell!.proImg.backgroundColor = UIColor.grayColor()
            }
            else{
                cell!.proImg.image = pending?.profileImg.image!
            }
            
            //rounds uiimage and configures UIImageView
            cell!.proImg.layer.cornerRadius = cell!.proImg.frame.size.width/2
            cell!.proImg.clipsToBounds = true
            //cell!.proImage.layer.borderColor = UIColor.whiteColor().CGColor
            //cell!.proImage.layer.masksToBounds = true
            
            
            return cell!
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
