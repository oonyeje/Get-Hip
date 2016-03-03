//
//  PartyServiceManager.swift
//  GetHip
//
//  Created by Okechi on 1/22/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import MediaPlayer


protocol PartyServiceManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>)
    
    
}

enum PeerType : Int {
    case Host_Creator = 0
    case Guest_Creator = 1
    case Host_Invited = 2
    case Guest_Invited = 3
}

enum HostSignalType: String {
    case PauseAudio = "Pause"
    case PlayAudio = "Play"
}



class PartyServiceManager: NSObject {

    let PartyServiceType = "GetHip-Party"
    var serviceAdvertiser: MCNearbyServiceAdvertiser! = nil
    var myPeerID: MCPeerID! = nil
    var serviceBrowser: MCNearbyServiceBrowser! = nil
    var session: MCSession! = nil
    var delegate: PartyServiceManagerDelegate?
    
    //peer variables
    var foundPeers: [MCPeerID] = [MCPeerID]()
    var invitedFriends: [FriendData] = []
    var role: PeerType! = nil
    var currentHost: String!
    
    var connectedPeersDictionary = NSMutableDictionary()
    var disconnectedPeersDictionary = NSMutableDictionary()
    
    //party variables
    var currentSong: MPMediaItem! = nil
    
    
    
    //Peer Initializer
    func setPeerID(dispName: String){
        self.myPeerID = MCPeerID(displayName: dispName)
        println("PeerID set to %@", self.myPeerID.displayName)
    }
    
    func setRole(peerRole: PeerType){
        self.role = peerRole
        println("Role set to %@", self.role.rawValue)
    }
    
    func chooseNextHost(){
        var numPeers = self.connectedPeers().count
        var nextHostIndex: Int = Int(arc4random_uniform(UInt32(numPeers)))
    
        if (self.connectedPeers()[nextHostIndex].displayName == self.currentHost){
            chooseNextHost()
        }else{
            self.currentHost = self.connectedPeers()[nextHostIndex].displayName
        }
    }
    
    func isPeerFound(peer: MCPeerID) -> Bool {
        for i in 0..<self.foundPeers.count{
            if(self.foundPeers[i].displayName == peer.displayName){
                return true
            }
        }
        return false;
    }
    
    //Party Instruction Sender
    func sendInstruction(dictionary: Dictionary<String, String>, toPeer: MCPeerID) -> Bool {
        
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        let peersArray = NSArray(object: toPeer)
        var error: NSError?
        
        if !(self.session.sendData(dataToSend, toPeers: peersArray as [AnyObject], withMode: MCSessionSendDataMode.Reliable, error: &error)){
            println(error?.localizedDescription)
            return false
        }
        
        return true
    }
    
    //Listening methods
    func setAdvertiser(){
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: self.PartyServiceType)
        self.serviceAdvertiser!.delegate = self
        println("Advertiser Set")
    }
    
    func startListening(){
        self.serviceAdvertiser.startAdvertisingPeer()
        println("Started Listening for invitations")
    }
    
    func stopListening(){
        self.serviceAdvertiser.stopAdvertisingPeer()
        println("Stopped listening for invitations")
    }
    
    //Browsing Methods
    func setBrowser(){
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.myPeerID, serviceType: self.PartyServiceType)
        self.serviceBrowser.delegate = self
        println("Browser Set")
    }
    
    func startBrowser(){
        self.serviceBrowser.startBrowsingForPeers()
        println("Started Browsing for peers")
    }
    
    func stopBrowsing(){
        self.serviceBrowser.stopBrowsingForPeers()
        println("Stopped Browsing for peers")
    }
    
    //Stop all services
    func stopAllServices(){
        stopBrowsing()
        stopListening()
        self.serviceBrowser.delegate = nil
        self.serviceAdvertiser.delegate = nil
        self.session.delegate = nil
        self.serviceBrowser = nil
        self.serviceAdvertiser = nil
        self.session = nil
    }
    
    //Audio Streaming methods
    func openOutputStream() -> NSMutableArray{
        
        var outputs: NSMutableArray?
        for peer in self.session.connectedPeers {
            outputs?.addObject(self.session.startStreamWithName("music", toPeer: peer as! MCPeerID, error: nil))
        }
        
        return outputs!
    }
    
    func outputStreamForPeer(peer: MCPeerID) -> NSOutputStream {
       return session.startStreamWithName("music", toPeer: peer, error: nil)
    }
    
    //Host Methods
    func initializeSession(){
        self.session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        self.session.delegate = self
        println("Initialized Peer-To-Peer Connection")
    }
    
    func setSong(media: MPMediaItem!){
        self.currentSong = media
    }
    
    //Deprecated
    /*
    func setData(dispName: String){
        
        //initialize session variable
        self.myPeerID = MCPeerID(displayName: dispName)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: self.PartyServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.myPeerID, serviceType: self.PartyServiceType)
        self.session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        
        //assign session delegates
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        self.session.delegate = self

        //start all services
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
    */
    
    func connectedPeers() -> [AnyObject]{
        return self.session.connectedPeers
    }

}


//delegate extensions
extension PartyServiceManager: MCNearbyServiceBrowserDelegate{
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        
        if(!isPeerFound(peerID)){
            if(peerID.displayName != self.myPeerID.displayName) {
                NSLog("%@", "foundPeer: \(peerID)")
                self.foundPeers.append(peerID)
                self.delegate?.foundPeer()
                //self.serviceBrowser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: NSTimeInterval(60.00))
                
            }
            
            
        }
        
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        NSLog("%@", "lostPeer: \(peerID)")
        
        if(isPeerFound(peerID)){
            for(index, aPeer) in enumerate(foundPeers) {
                if aPeer == peerID{
                    foundPeers.removeAtIndex(index)
                    break
                }
            }
            
            delegate?.lostPeer()
        }
        
        
    }
}

extension PartyServiceManager: MCNearbyServiceAdvertiserDelegate{
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")

    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        NSLog("%@", "invitingPeer: \(peerID)")
        self.setRole(PeerType(rawValue: 3)!)
        delegate?.invitationWasRecieved(peerID, invitationHandler: invitationHandler)
    }
}

extension PartyServiceManager: MCSessionDelegate{
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
        if(state == MCSessionState.Connected){
            println(self.myPeerID.displayName + " connected to " + peerID.displayName)
            println("mark 1")
            self.delegate?.connectedWithPeer(peerID)
            
        }
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        NSLog("%@", "didRecieveData: \(data)")
        
        let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        self.delegate?.didRecieveInstruction(dictionary)
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        NSLog("%@", "didRecieveStream: \(streamName) from peer: \(peerID)")
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        NSLog("%@", "didFinishReceivingResourceWithName: \(resourceName) from peer: \(peerID)")
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        NSLog("%@", "didStartReceivingResourceWithName: \(resourceName) from peer: \(peerID)")
    }
    
    
}

//state extensions

extension MCSessionState{
    func stringValue() -> String {
        switch(self){
        case .NotConnected: return "NotConnected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        default: return "Unknown"
        }
    }
}
