//
//  TestInviteFriendsController.swift
//  GetHip
//
//  Created by Okechi on 1/23/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TestInviteFriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource, PartyServiceManagerDelegate {
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    var isFriendSelected: [Bool] = []
    var isInvitable: [Bool] = []
    var partyData: PartyServiceManager! = nil
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func cancelInvites(sender: UIBarButtonItem) {
        //println("Browser service deinitialized and browser deinitialized")
        self.partyData.stopBrowsing()
        self.partyData.serviceBrowser = nil
        
        self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendInvites(sender: UIButton) {
        var numSelected = 0
        
        for booli in self.isFriendSelected {
            if booli == true {
                numSelected++
            }

        }
        
        if(numSelected > 0){
            self.performSegueWithIdentifier("selectSongSegue", sender: sender)
        }
        else{
            println("Select a friend")
        }
    }
    
    
    func setData(usrDat: [UserParseData], frndData: [FriendData], party: PartyServiceManager, request: [FriendData]){
        self.usr = usrDat
        self.frnds = frndData
        self.partyData = party
        self.requestData = request
        
        for i in 0..<self.frnds.count{
            self.isFriendSelected.append(false)
            self.isInvitable.append(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.dataSource = self
        self.table.delegate = self
        self.partyData.delegate = self
        //start browsing for peers
        self.partyData.setBrowser()
        self.partyData.startBrowser()
        self.partyData.initializeSession()
        self.navigationController?.navigationBarHidden = false
        
        for foundPeer in self.partyData.foundPeers {
            for friend in self.frnds {
                if foundPeer.displayName == friend.displayName {
                    for(index, aFriend) in enumerate(self.frnds) {
                        if aFriend.displayName == friend.displayName {
                            self.isInvitable[index] = true
                            break
                        }
                    }
                }
            }
        }
        
        

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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.frnds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friend = self.frnds[indexPath.row]
        let cell = self.table.dequeueReusableCellWithIdentifier("TestInviteCell", forIndexPath: indexPath) as? TestInviteFriendsCell
        
        //sets display name of friend (print for debugging purposes)
        cell!.friendName.text = friend.displayName
        println(friend.displayName)
        
        //sets profile image of current cell
        //checks if friend user has a profile image or not
        if friend.profileImg == nil {
            cell!.proImage.backgroundColor = UIColor.grayColor()
        }
        else{
            cell!.proImage.image = friend.profileImg.image!
        }
        
        //rounds uiimage and configures UIImageView
        //cell!.proImage.layer.borderWidth = 3.0
        //cell!.proImage.clipsToBounds = true
        cell!.proImage.layer.cornerRadius = cell!.proImage.frame.size.width/2
        //cell!.proImage.layer.borderColor = UIColor.whiteColor().CGColor
        //cell!.proImage.layer.masksToBounds = true
        cell!.rdioButton.layer.cornerRadius = cell!.rdioButton.frame.size.width/2
        
        //for testing purposes - MPCBrowsing
        if(self.isInvitable[indexPath.row] == true){
            cell!.proImage.alpha = 0.5
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = table.cellForRowAtIndexPath(indexPath) as? TestInviteFriendsCell
        
        if self.isFriendSelected[indexPath.row] == false{
            cell!.rdioButton.setBackgroundImage(UIImage(named: "Blue Check.png"), forState: UIControlState.Normal)
            self.isFriendSelected[indexPath.row] = true
        }
        else{
            cell!.rdioButton.setBackgroundImage(UIImage(named: "Tap Circle.png"), forState: UIControlState.Normal)
            self.isFriendSelected[indexPath.row] = false
        }

        
    }
    
    //Navigation preperation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var invited: [FriendData] = []
        for var i = 0; i < self.isFriendSelected.count; i++ {
            if (self.isFriendSelected[i] == true) {
                invited.append(self.frnds[i])
            }
        }
        self.partyData.invitedFriends = invited
        let vc: SongSelectionViewController = (segue.destinationViewController as? SongSelectionViewController)!
        vc.setData(self.partyData, user: self.usr, friends: self.frnds, request: self.requestData)
        println(invited.count)
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

extension TestInviteFriendsController: PartyServiceManagerDelegate {
    func foundPeer() {
        self.table.reloadData()
    }
    
    func lostPeer() {
        self.table.reloadData()
    }
    
    func invitationWasRecieved(fromPeer: String) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
    }
}
