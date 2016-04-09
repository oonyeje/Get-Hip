//
//  FriendsListViewController.swift
//  GetHip
//
//  Created by Okechi on 1/5/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PartyServiceManagerDelegate {
    //var manager = FriendDataSource()
    var friends = []
    var request = []
    var user: [UserParseData]!
    var party: PartyServiceManager!
    
    @IBOutlet weak var table: UITableView!
    
    /*
    @IBAction func dismissFriendView(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.navigationBarHidden = false

    }
    */
    @IBAction func addFriend(sender: UIBarButtonItem){
        self.performSegueWithIdentifier("FriendRequestSegue", sender: nil)
    }
    
    @IBAction func reloadList(sender: UIBarButtonItem){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshFriends:", name: "reloadDataF", object: nil)
        (self.tabBarController as! HomeTabController).reloadParseData()
    }
    
    func refreshFriends(notification: NSNotification){
        self.viewDidLoad()
        self.table.reloadData()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadDataF", object: nil)
    }
    
    func setData(frnds:[FriendData], requst: [FriendData], party: PartyServiceManager, user: [UserParseData]){
        self.friends = frnds
        self.request = requst
        self.party = party
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for sharing data with tab bar navigations
        self.user = (self.tabBarController as? HomeTabController)!.userData
        self.party = (self.tabBarController as? HomeTabController)!.partyData
        self.friends = (self.tabBarController as? HomeTabController)!.friendData
        self.request = (self.tabBarController as? HomeTabController)!.requestData
        
        self.table.delegate = self
        self.table.dataSource = self
        self.party.delegate = self
        self.title = "Friends"
        self.navigationController?.navigationBarHidden = false
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if( indexPath.row == 0){
            let cell = self.table.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as? FriendRequestCell
            
            self.table.rowHeight = cell!.bounds.size.height
            //sets count for current number of request
            cell?.requestNumber.text = String(self.request.count)
            return cell!
            
        }
        else{
            
            let friend = self.friends[indexPath.row - 1] as? FriendData
            let cell = self.table.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? FriendsCell
            
            //sets display name of friend (print for debugging purposes)
            cell!.friendName.text = friend!.displayName
            self.table.rowHeight = cell!.bounds.size.height
            //println(friend!.displayName)
            
            //sets profile image of current cell
            //checks if friend user has a profile image or not
            if friend?.profileImg == nil {
                cell!.proImage.backgroundColor = UIColor.grayColor()
            }
            else{
                cell!.proImage.image = friend?.profileImg!.image!
            }
            
            //rounds uiimage and configures UIImageView
            //cell!.proImage.layer.borderWidth = 3.0
            cell!.proImage.layer.cornerRadius = cell!.proImage.frame.size.width/2
            cell!.proImage.clipsToBounds = true
            //cell!.proImage.layer.borderColor = UIColor.whiteColor().CGColor
            //cell!.proImage.layer.masksToBounds = true
            
            
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0){
            if(self.request.count == 0){
                self.performSegueWithIdentifier("NoRequestSegue", sender: nil)
            }else{
                self.performSegueWithIdentifier("PendingRequestSegue", sender: nil)
            }
        }
        
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        println(indexPath.row)
        if indexPath.row == 0{
            let cell = self.table.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as? FriendRequestCell
            
            return cell?.bounds.size.height as CGFloat!
        }else{
            let cell = self.table.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? FriendsCell
            
            return cell?.bounds.size.height as CGFloat!

        }
    }*/
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.table.setEditing(editing, animated: true)
        if editing{
            
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            //delete friend from users friend array, parse, and tableView
            println("delete")
        default:
            return
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PendingRequestSegue" {
            
            let vc: PendingRequestViewController = (segue.destinationViewController as? PendingRequestViewController)!
            vc.setData(self.request as! [FriendData], party: self.party)
            
        }
        
        if segue.identifier == "FriendRequestSegue" {
           var frndNames: [String] = []
            println(self.friends.count)
            if (self.friends.count != 0){
                for i in 0...self.friends.count-1{
                    var frends: FriendData! = self.friends[i] as! FriendData
                    println(frends.email!)
                    frndNames.append(frends.email!)
                }
            }
            
            
            let vc: FriendRequestViewController = (segue.destinationViewController as? FriendRequestViewController)!
            vc.setData(frndNames, party: self.party)
        }
    }

}

extension FriendsListViewController: PartyServiceManagerDelegate {
    func foundPeer() {
        
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: InvitedToPartyViewController = storyboard.instantiateViewControllerWithIdentifier("InvitedToPartyVC") as! InvitedToPartyViewController!
        vc.setData(self.party, user: self.user, friends: (self.friends as! [FriendData]), request: (self.request as! [FriendData]), invHand: invitationHandler, fromPeer: peerID)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
    
    }
}

