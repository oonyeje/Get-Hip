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

    func setData(data: [FriendData]){
        self.requests = data
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
                
            }
            
            //rounds uiimage and configures UIImageView
            //cell!.proImage.layer.borderWidth = 3.0
            //cell!.proImage.clipsToBounds = true
            cell!.proImg.layer.cornerRadius = cell!.proImg.frame.size.width/2
            
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
