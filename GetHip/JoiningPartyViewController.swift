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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JoiningPartyViewController: PartyServiceManagerDelegate {
    
    func foundPeer() {
        
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        println("mark 2")
        var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "joined_party"]
        self.party.sendInstruction(dictionary, toPeer: peerID)
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
        
    }
    
}
