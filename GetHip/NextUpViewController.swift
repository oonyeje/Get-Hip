//
//  NextUpViewController.swift
//  GetHip
//
//  Created by Okechi on 3/14/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NextUpViewController: UIViewController, PartyServiceManagerDelegate {
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    @IBOutlet weak var userImages: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.party.delegate = self
        self.userImages.layer.cornerRadius = self.userImages.frame.size.width/2
        self.userImages.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setData(prty:PartyServiceManager, user: [UserParseData], friends: [FriendData], request: [FriendData]){
        self.party = prty
        self.usr = user
        self.frnds = friends
        self.requestData = request
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "NextSongSegue"){
            let vc: CurrentlyPlayingViewController = (segue.destinationViewController as? CurrentlyPlayingViewController)!
            
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
        }
    }
    

}

extension NextUpViewController: PartyServiceManagerDelegate {
    
    func foundPeer() {
        
    }
    
    func lostPeer() {
    }
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
        let (instruction, fromPeer) = self.party.decodeInstruction(dictionary)
        
        if self.party.disconnectedPeersDictionary[fromPeer.displayName] != nil {
            
            var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "disconnect"]
            self.party.sendInstruction(dictionary, toPeer: fromPeer)
        }else{
            if (instruction == "start_party"){
                self.performSegueWithIdentifier("NextSongSegue", sender: self)
            }
        }

    }
    
    
}
