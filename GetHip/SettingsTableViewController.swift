//
//  SettingsTableViewController.swift
//  GetHip
//
//  Created by Okechi on 1/21/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
   // var manager = UserParseDataSource()
    var user = []
    
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var table: UITableView!
    
    @IBAction func dismissSettingsView(sender: UIBarButtonItem) {
        
        self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func logOutUser(sender: UIButton) {
        PFUser.logOut()
        
        if PFUser.currentUser() == nil {
        
            self.performSegueWithIdentifier("LogOutSegue", sender: sender)
            
        }
        
    }
    
    func setData(usr:[UserParseData]){
        self.user = usr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        
        self.logOutBtn.layer.borderWidth = 1
        self.logOutBtn.layer.cornerRadius = 5
        self.logOutBtn.layer.borderColor = UIColor.blackColor().CGColor
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "refreshSettingsView", object: nil)
        
        self.table.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(indexPath.row)
        switch indexPath.row {
        case 0:
            let cell = (self.tableView.dequeueReusableCellWithIdentifier("DispNameCell", forIndexPath: indexPath) as? DisplayNameCell)!
            
            if self.user.count > 0 {
                cell.dispName.text = (self.user[0] as? UserParseData)!.displayName
            }
            
            return cell
            
        case 1:
            let cell = (self.tableView.dequeueReusableCellWithIdentifier("UserNameCell", forIndexPath: indexPath) as? UserNameCell)!
            
            if self.user.count > 0 {
                cell.usrName.text = (self.user[0] as? UserParseData)!.username
            }
            
            return cell
            
        case 2:
            let cell = (self.tableView.dequeueReusableCellWithIdentifier("EmailCell", forIndexPath: indexPath) as? EmailCell)!
            
            if self.user.count > 0 {
                cell.email.text = (self.user[0] as? UserParseData)!.email
            }
            
            return cell
        case 3:
            let cell = (self.table.dequeueReusableCellWithIdentifier("PassCell", forIndexPath: indexPath) as? ResetPassCell)!
            
            if self.user.count > 0 {
                
            }
            
            return cell
        default:
            let cell = (self.table.dequeueReusableCellWithIdentifier("PictureCell", forIndexPath: indexPath) as? ProfilePicCell)!
            
            if self.user.count > 0 {
                
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
            
        //display name view
        case 0:
            
            if self.user.count > 0 {
                
                self.performSegueWithIdentifier("DisplayNameSegue", sender: nil)
            }
            
        //user name view
        case 1:
            
            if self.user.count > 0 {
                
                
            }
            
            break
            
        //email view
        case 2:
            
            if self.user.count > 0 {
                self.performSegueWithIdentifier("EmailSegue", sender: nil)
            }
        
        //reset pass
        case 3:
            
            if self.user.count > 0 {
                
            }
            break
            
        //Profile Picture View
        default:
            
            if self.user.count > 0 {
                self.performSegueWithIdentifier("PhotoSegue", sender: nil)
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.table.indexPathForSelectedRow() {
            
            switch indexPath.row {
                
            //display name view
            case 0:
                if self.user.count > 0 {
                    let vc: DisplayDetailViewController = (segue.destinationViewController as? DisplayDetailViewController)!
                    vc.setData((self.user[0] as? UserParseData)!.displayName)
                    
                    println(vc.displayName)
                }
                
                //email view
            case 2:
                
                if self.user.count > 0 {
                    let vc: EmailDetailViewController = (segue.destinationViewController as? EmailDetailViewController)!
                    vc.setData((self.user[0] as? UserParseData)!.email)
                    
                    println(vc.email)
                }
                
                //reset pass
            case 3:
                
                if self.user.count > 0 {
                    
                }
                
                //Profile Picture View
            default:
                
                if self.user.count > 0 {
                    let vc: ProfileDetailViewController = (segue.destinationViewController as? ProfileDetailViewController)!
                    vc.setData()
                    println("img")
                }
                
            }
            
        }
        
    }
    
   /* func refreshTable(notification: NSNotification){
        self.user = manager.getUser()
        self.table.reloadData()
    }*/
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
