//
//  InvitedToPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 2/20/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InvitedToPartyViewController: UIViewController , PartyServiceManagerDelegate{
    var friendData: [FriendData] = []
    var requestData: [FriendData] = []
    var userData: [UserParseData] = []
    var partyData: PartyServiceManager!
    var inviteHandle: ((Bool, MCSession!) -> Void)!
    private var fromPeer: MCPeerID!
    var shouldEndInvite = false
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var inviteTxt: UITextView!
    
    @IBAction func declineInvite(sender: UIButton){
        self.inviteHandle(false, self.partyData.session)
        self.shouldEndInvite = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func acceptInvite(sender: UIButton){
        self.partyData.currentHost = self.fromPeer.displayName
        self.inviteHandle(true, self.partyData.session)
        self.shouldEndInvite = true
        self.performSegueWithIdentifier("JoiningPartySegue", sender: self)
        /*self.dismissViewControllerAnimated(true, completion: {
            () -> Void in
            
            
        })*/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var query = PFQuery(className: "_User")
        query.whereKey("displayName", equalTo: self.fromPeer.displayName)
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            query.getFirstObjectInBackgroundWithBlock({
                (object: PFObject?, error: NSError?) -> Void in
                if(error == nil){
                    self.inviteTxt.text = "You have been invited by " + (object?.objectForKey("displayName")! as? String)! + " to join a Party!"
                    
                    //download profile imge
                    var img = object!.objectForKey("profilePicture")! as? PFFile
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        img!.getDataInBackgroundWithBlock({
                            (imgData, error) -> Void in
                            
                            var downloadedImg = UIImage(data: imgData!)
                            self.img.image = downloadedImg
                            self.img.layer.cornerRadius = self.img.frame.size.width/2
                            self.img.clipsToBounds = true
                        })
                    })
                }
            })
        })
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if(self.shouldEndInvite == true){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(prty:PartyServiceManager, user: [UserParseData], friends: [FriendData], request: [FriendData], invHand: ((Bool, MCSession!) -> Void)!, fromPeer: MCPeerID){
        self.partyData = prty
        self.userData = user
        self.friendData = friends
        self.requestData = request
        self.inviteHandle = invHand
        self.fromPeer = fromPeer
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "InvitedToPartySettingsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: SettingsTableViewController = (nav.viewControllers[0] as? SettingsTableViewController)!
            vc.setData(self.userData, prty: self.partyData, frends: self.friendData, request: self.requestData)
        }
        
        if segue.identifier == "InvitedToPartyFriendsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: FriendsListViewController = (nav.viewControllers[0] as? FriendsListViewController)!
            vc.setData(self.friendData, requst: self.requestData, party: self.partyData, user: self.userData)
        }
        
        if segue.identifier == "JoiningPartySegue" {
            let vc: JoiningPartyViewController = (segue.destinationViewController as? JoiningPartyViewController)!
            
            vc.setData(self.friendData, requst: self.requestData, party: self.partyData, user: self.userData)
        }
    }
    
    
    
}

extension InvitedToPartyViewController: PartyServiceManagerDelegate {
    
    func foundPeer() {
        
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        println("mark 0")
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
        
    }

    
}