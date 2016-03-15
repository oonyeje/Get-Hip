//
//  LoadingPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 2/8/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MediaPlayer
import MultipeerConnectivity
import AVFoundation

class LoadingPartyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PartyServiceManagerDelegate{
    //persistant data
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []

    //controller data
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var invitedFriends: UICollectionView!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var arePeersReady = Dictionary<String, Bool>()
    private var firstPass: Bool = true
    var timer = NSTimer()
    var counter = 30
    
    @IBAction func cancelInvites(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chngSong(sender: UIButton){
    
        //cancel all current operations
        
        //go back to song selection
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.invitedFriends.dataSource = self
        self.invitedFriends.delegate = self
        
        if(self.firstPass){
            // Do any additional setup after loading the view.
            self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
            self.songLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)! + " by " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)!
            
            //sets up timer label and starts countdown to next screen
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateThumbnail:", name: "peerConnected", object: nil)
            self.timerLabel.text = String(counter)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
            self.firstPass = false
        }
        
        self.party.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCounter(){
        self.timerLabel.text = String(counter--)
        println(self.timerLabel.text)
        if(self.counter == -1){
            self.timer.invalidate()
            prepareAndCheckPeers()
            //self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("prepareAndCheckPeers"), userInfo: nil, repeats: false)
            //self.performSegueWithIdentifier("CurrentlyPlayingSegue", sender: nil)
        }
    }
    
    //selector functions for prepareAndCheckPeers selector function
    func checkIfReady(){
        for peer in self.party.session.connectedPeers as! [MCPeerID] {
            var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "are_you_ready", "connectedPeers": (self.party.session.connectedPeers as! [MCPeerID])]
            self.party.sendInstruction(dictionary, toPeer: peer)
        }
        
        var delayStart = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("attemptToStart"), userInfo: nil, repeats: false)
    }
    
    func startParty(){
        var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "start_party"]
        
        for peer in self.party.session.connectedPeers as! [MCPeerID] {
            self.party.sendInstruction(dictionary, toPeer: peer )
        }
        
        self.performSegueWithIdentifier("CurrentlyPlayingSegue", sender: self)
        
    }
    
    func attemptToStart(){
        
        
        
        for peer in self.party.session.connectedPeers as! [MCPeerID] {
            if self.arePeersReady[peer.displayName] == false{
                var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "disconnect"]
                self.party.sendInstruction(dictionary, toPeer: peer)
            }
        }
        
        var delTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("startParty"), userInfo: nil, repeats: false)
        
        
    }

    
    func prepareAndCheckPeers(){
        
        for connPeers in self.party.session.connectedPeers as! [MCPeerID] {
            self.arePeersReady[connPeers.displayName] = false
        }
        
        
        for invited in self.party.invitedFriends {
            var joinedPeer: MCPeerID? = self.party.connectedPeersDictionary[invited.displayName] as? MCPeerID
            
            if joinedPeer == nil {
                for aPeer in self.party.foundPeers {
                    
                    if aPeer.displayName == invited.displayName {
                        self.party.session.cancelConnectPeer(aPeer)
                        self.party.disconnectedPeersDictionary.setValue(aPeer, forKey: aPeer.displayName)
                        break
                    }
                }
            }else{
                //sends array of currently connected peers to every connected peer to set up mesh streaming network
                var currentlyConnected : [FriendData]! = []
                for peer in self.party.session.connectedPeers as! [MCPeerID]{
                    for friend in self.party.invitedFriends {
                        if peer.displayName == friend.displayName {
                            currentlyConnected.append(friend)
                        }
                    }
                }
                var userDat = FriendData(display: self.usr[0].displayName, status: "", username: self.usr[0].username)
                userDat.profileImg = UIImageView(image: self.usr[0].profileImg.image)
                currentlyConnected.append(userDat)
                
                var dictionaryConnected: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "connect_to_other_peers", "connectedPeers": self.party.session.connectedPeers as! [MCPeerID], "friendData": currentlyConnected]
                self.party.sendInstruction(dictionaryConnected, toPeer: joinedPeer!)
                var delayCheck = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkIfReady"), userInfo: nil, repeats: false)
                
                
                //var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "start_party"]
                //self.party.sendInstruction(dictionary, toPeer: joinedPeer! )
                
                //start streaming to connected peers
                //self.party.outputStreamers[joinedPeer!.displayName]!.start()
                
                
                
            }
            
        }

    }
    
    func setData(prty:PartyServiceManager, user: [UserParseData], friends: [FriendData], request: [FriendData]){
        self.party = prty
        self.usr = user
        self.frnds = friends
        self.requestData = request
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let friend = self.party.invitedFriends[indexPath.row]
        let cell: InvitedCollectionViewCell = self.invitedFriends.dequeueReusableCellWithReuseIdentifier("InvitedCollectionCell", forIndexPath: indexPath) as! InvitedCollectionViewCell
        
        if friend.profileImg == nil {
            cell.friendImage.backgroundColor = UIColor.grayColor()
        }
        else{
            cell.friendImage.image = friend.profileImg.image!
        }
        
        //rounds uiimage and configures UIImageView
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.width/2
        cell.friendImage.clipsToBounds = true
        
        if(self.party.connectedPeersDictionary[friend.displayName] == nil){
            cell.alpha = 0.5
        }
        
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.party.invitedFriends.count
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "CurrentlyPlayingSegue"){
            /*
            //PLACE THIS CODE IN A SEPARATE FUNCTION SO YOU CAN CONTROL TIMING BETTER AND MAKE SURE ALL PEERS ARE READY BEFORE MOVING ON
            //ends invitations with outstanding peers
            for invited in self.party.invitedFriends {
                var joinedPeer: MCPeerID? = self.party.connectedPeersDictionary[invited.displayName] as? MCPeerID
                
                if joinedPeer == nil {
                    for aPeer in self.party.foundPeers {
                        
                        if aPeer.displayName == invited.displayName {
                            self.party.session.cancelConnectPeer(aPeer)
                            self.party.disconnectedPeersDictionary.setValue(aPeer, forKey: aPeer.displayName)
                            break
                        }
                    }
                }else{
                    //sends array of currently connected peers to every connected peer to set up mesh streaming network
                    var currentlyConnected : [FriendData]!
                    for peer in self.party.session.connectedPeers as! [MCPeerID]{
                        for friend in self.party.invitedFriends {
                            if peer.displayName == friend.displayName {
                                currentlyConnected.append(friend)
                            }
                        }
                    }
                    var dictionaryConnected: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "connect_to_other_peers", "connectedPeers": self.party.session.connectedPeers as! [MCPeerID], "friendData": currentlyConnected]
                    self.party.sendInstruction(dictionaryConnected, toPeer: joinedPeer!)
                  //END OF NOTE

                        var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "start_party"]
                        self.party.sendInstruction(dictionary, toPeer: joinedPeer! )
                        
                        //start streaming to connected peers
                        //self.party.outputStreamers[joinedPeer!.displayName]!.start()
                    
                    
                    
                }
                
            }
            
            
            
            
            /*if !(self.session.sendData(dataToSend, toPeers: peersArray as [AnyObject], withMode: MCSessionSendDataMode.Reliable, error: &error)){
                println(error?.localizedDescription)
                return false
            }*/
            */
            let vc: CurrentlyPlayingViewController = (segue.destinationViewController as? CurrentlyPlayingViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
        }
    }
    

}

extension LoadingPartyViewController: PartyServiceManagerDelegate {
    
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
        
            if (instruction == "joined_party") {
                println(instruction)
                
                var i = 0
                for(index, aFriend) in enumerate(self.party.invitedFriends) {
                    if aFriend.displayName == fromPeer.displayName {
                        i = index
                        break
                    }
                }
                
                
                
                self.party.connectedPeersDictionary.setValue(fromPeer, forKey: fromPeer.displayName)
                self.invitedFriends.reloadData()
                
                
                //prepares party for the guest peers
                
                //sends music info incuding, title, artist, album, and image
                var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID.displayName, "instruction": "set_up_song", "songTitle": (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)!, "songArtistAndAlbum": (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)! + " - " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!)!, "songImage": UIImagePNGRepresentation(self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size))]
                
                self.party.sendInstruction(dictionary, toPeer: fromPeer)
                
                //open stream with peer
                let stream = self.party.outputStreamForPeer(fromPeer)
                self.party.outputStreamers[fromPeer.displayName] = TDAudioOutputStreamer(outputStream: stream)
                self.party.outputStreamers[fromPeer.displayName]!.streamAudioFromURL((self.party.currentSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL))
                
                
                
                
                
                /*
                let asset: AVURLAsset? = AVURLAsset(URL: (self.party.currentSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL), options: nil)
                
                var error: NSError?
                
                let assetReader: AVAssetReader = AVAssetReader(asset: asset, error: &error)
                
                let assetOutput: AVAssetReaderTrackOutput = AVAssetReaderTrackOutput(track: asset!.tracks[0] as! AVAssetTrack, outputSettings: nil)
                
                if error != nil {
                    
                }else{
                    //for peer in self.party.session.connectedPeers {
                        assetReader.addOutput(assetOutput)
                        assetReader.startReading()
                        
                        let sampleBuffer:CMSampleBuffer! = assetOutput.copyNextSampleBuffer()
                        
                        var audioBufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: AudioBuffer(mNumberChannels: 0, mDataByteSize: 0, mData: nil))
                        
                        var blockBuffer: Unmanaged<CMBlockBuffer>? = nil
                        
                        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, nil, &audioBufferList, Int(sizeof(audioBufferList.dynamicType)), nil, nil, UInt32(kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment), &blockBuffer)
                        
                        let stream = self.party.outputStreamForPeer(fromPeer) //self.party.session.startStreamWithName("music", toPeer: peer as! MCPeerID, error: &error)
                        
                        if error != nil {
                            print("Error stream: \(error?.localizedDescription)")
                        }
                        
                        for (var i: UInt32 = 0; i < audioBufferList.mNumberBuffers; i++){
                            var audioBuffer = AudioBuffer(mNumberChannels: audioBufferList.mBuffers.mNumberChannels, mDataByteSize: audioBufferList.mBuffers.mDataByteSize, mData: audioBufferList.mBuffers.mData)
                            stream.write(UnsafeMutablePointer<UInt8>(audioBuffer.mData), maxLength: Int(audioBuffer.mDataByteSize))
                        }
                    //}
                    
                    //CFRelease(blockBuffer)
                    //CFRelease(sampleBuffer)
                    
                }*/


            }
            
            if(instruction == "ready"){
                self.arePeersReady[fromPeer.displayName] = true
            }
            
            println(instruction)

        }
        
        
    }
    
}