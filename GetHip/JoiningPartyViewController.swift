//
//  JoiningPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 3/2/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JoiningPartyViewController: UIViewController ,PartyServiceManagerDelegate{
    var friends = []
    var request = []
    var user: [UserParseData]!
    var party: PartyServiceManager!
    private var isHostConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.party.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(frnds:[FriendData], requst: [FriendData], party: PartyServiceManager, user: [UserParseData]){
        self.friends = frnds
        self.request = requst
        self.party = party
        self.user = user
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "EnteringPartySegue"{
            
            let vc: CurrentlyPlayingViewController = (segue.destinationViewController as? CurrentlyPlayingViewController)!
            
            vc.setData(self.party, user: self.user, friends: self.friends as! [FriendData], request: self.request as! [FriendData])
        }
    }
    

}

extension JoiningPartyViewController: PartyServiceManagerDelegate {
    
    func foundPeer() {
        
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        if(self.isHostConnected == true){
            if(self.party.connectedPeersDictionary[ peerID.displayName] == nil){
                invitationHandler(true, self.party.session)
            }
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        println("mark 2")
        
        
        if(self.isHostConnected == false){
            var dictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dictionary["sender"] = self.party.myPeerID.displayName
            dictionary["instruction"] = "joined_party"
            self.party.sendInstruction(dictionary, toPeer: peerID)
            self.isHostConnected = true
        }
        
        
        
        
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
        let (instruction, fromPeer) = self.party.decodeInstruction(dictionary)
        
        if (instruction == "disconnect") {
            self.party.session.disconnect()
            
            if let vc = self.parentViewController as? InvitedToPartyViewController{
                vc.shouldEndInvite = true
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
        if (instruction == "start_party"){
            println("mark 4")
            self.performSegueWithIdentifier("EnteringPartySegue", sender: self)
        }
        
     
    }
    
}
