//
//  CurrentlyPlayingViewController.swift
//  GetHip
//
//  Created by Okechi on 2/10/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import MultipeerConnectivity

class CurrentlyPlayingViewController: UIViewController, PartyServiceManagerDelegate{
    //persistant data
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    var audioPlayer: AVPlayer!
    var playing = true
    var timer = NSTimer()
    
    //controller data
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistAndAlbumLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
    //Host buttons
    @IBOutlet var volCtrl: UISlider!
    @IBOutlet var ppfButton: UIButton!
    
    @IBAction func volChng(sender: UISlider){
        self.audioPlayer.volume = sender.value
    }
    @IBAction func playPauseFav(sender: UIButton){
        if (self.party.role == PeerType.Host_Creator){
            if(playing == true){
                self.audioPlayer.pause()
                for peer in self.party.session.connectedPeers {
                    var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "pause_stream"]
                    self.party.sendInstruction(dictionary, toPeer: peer as! MCPeerID)
                }
                self.playing = false
                self.ppfButton.setBackgroundImage(UIImage(named: "Play-52.png"), forState: UIControlState.Normal)
                
            }else{
                self.audioPlayer.play()
                self.playing = true
                self.ppfButton.setBackgroundImage(UIImage(named: "Pause-52.png"), forState: UIControlState.Normal)
                for peer in self.party.session.connectedPeers {
                    var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "resume_stream"]
                    self.party.sendInstruction(dictionary, toPeer: peer as! MCPeerID)
                }
                
            }
        }
        
    }
    
    
    //Guest buttons
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        if(self.party.role == PeerType.Host_Creator){
            self.audioPlayer = AVPlayer(URL: self.party.currentSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL)
            
            self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
            self.titleLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)!
            self.artistAndAlbumLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)! + " - " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!)!
            self.audioPlayer.volume = self.volCtrl.value
            self.maxLabel.text = String(stringInterpolationSegment: self.audioPlayer.currentItem.duration.value)
            self.party.delegate = self
            for peer in self.party.session.connectedPeers {
                self.party.outputStreamers[peer.displayName]?.start()
            }
            self.audioPlayer.play()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateLabels"), userInfo: nil, repeats: true)
        }else if (self.party.role == PeerType.Guest_Invited){
            
            self.songImg.image = self.party.currentSongIMG
            self.titleLabel.text = (self.party.currentSongTitle)
            println(self.party.currentSongTitle)
            println(self.titleLabel.text)
            self.artistAndAlbumLabel.text = (self.party.currentSongArtistAlbum)
            self.party.delegate = self
            self.ppfButton.hidden = true
                        
            
            
            
        }
        
        

    }

    func updateLabels(){
        if (self.playing == true){
            var timeLeft = self.audioPlayer.currentItem.duration.value - self.audioPlayer.currentTime().value
            var interval = timeLeft
            var seconds = interval%60
            println(seconds)
            var minutes = (interval/60)%60
            println(minutes)
            //self.maxLabel.text
            //self.minLabel.text
        }
        
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
        
        if(segue.identifier == "InPartySegue"){
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: InPartyViewController = (nav.viewControllers[0] as? InPartyViewController)!
            vc.setData(self.party)
        }
        
        if segue.identifier == "BackToHomeScreenSegue" {
            let vc: BackToHomeScreenViewController = (segue.destinationViewController as? BackToHomeScreenViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
        }
    }
    

}

extension CurrentlyPlayingViewController: PartyServiceManagerDelegate {
    
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
            if(instruction == "pause_stream"){
                self.party.inputStreamer.pause()
            }else if(instruction == "resume_stream"){
                self.party.inputStreamer.resume()
            }
        }
            
        
        
        
    }
    
}
