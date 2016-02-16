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
    func didConnectToPeer(serviceManager: PartyServiceManager, didConnectToPeer peerIDName: String )
    
    func foundAPeer(serviceManager: PartyServiceManager, foundPeer: String)
    
    
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
   // var delegate: PartyServiceManagerDelegate?
    
    //peer variables
    var foundPeers: [String] = []
    var invitedFriends: [FriendData] = []
    var role: PeerType! = nil
    
    var connectingPeersDictionary = NSMutableDictionary()
    var disconnectedPeersDictionary = NSMutableDictionary()
    
    //party variables
    var currentSong: MPMediaItem! = nil
    
    /*init(){
        
        //self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: self.PartyServiceType)
        //super.init()
        //self.serviceAdvertiser.delegate = self
        
    }*/
    
    /*deinit {
        //stop all session services
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }*/
    
    /*lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        
    }()*/
    
    //Peer Initializer
    func setPeerID(dispName: String){
        self.myPeerID = MCPeerID(displayName: dispName)
        println("PeerID set to %@", self.myPeerID.displayName)
    }
    
    func setRole(peerRole: PeerType){
        self.role = peerRole
        println("Role set to %@", self.role.rawValue)
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
        
        if(peerID.displayName != self.myPeerID.displayName) {
            NSLog("%@", "foundPeer: \(peerID)")
            self.foundPeers.append(peerID.displayName)
            self.serviceBrowser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: NSTimeInterval(10.00))
            
        }
        
        //implement way of picking which friends from friend list are invited
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

extension PartyServiceManager: MCNearbyServiceAdvertiserDelegate{
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")

    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        NSLog("%@", "invitingPeer: \(peerID)")
        self.setRole(PeerType(rawValue: 3)!)
        invitationHandler(true, self.session)
    }
}

extension PartyServiceManager: MCSessionDelegate{
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        NSLog("%@", "didRecieveData: \(data)")
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
