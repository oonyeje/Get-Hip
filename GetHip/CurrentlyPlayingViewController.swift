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

class CurrentlyPlayingViewController: UIViewController, PartyServiceManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate{
    //persistant data
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    var audioPlayer: AVPlayer!
    var playing = true
    var timer = NSTimer()
    var nextHost: String!
    var messageOutputStream: Dictionary<String, NSOutputStream>!
    var messageInputStream: Dictionary<String, NSInputStream>!
    var firstPass = true
    @IBOutlet var segmentControl: UISegmentedControl!
    
    //class variable for responding to peer who has just sent a message
    private var curr_fromPeer: MCPeerID!
    
    @IBAction func switchViews(segCtrl: UISegmentedControl){
    
        if(segCtrl.selectedSegmentIndex == 0){
            //hide all in party view elements
            self.friendsInParty.hidden = true
            self.leaveOrEnd.hidden = true
            self.leaveOrEnd.enabled = false
            self.addMore.hidden = true
            self.addMore.enabled = true
            
            
            //show all relevent current playing ui components
            self.songImg.hidden = false
            self.titleLabel.hidden = false
            self.artistAndAlbumLabel.hidden = false
            self.minLabel.hidden = false
            self.maxLabel.hidden = false
            self.progressBar.hidden = false
            
            if(self.party.role == PeerType.Host_Creator || self.party.role == PeerType.Guest_Creator){
            
                self.volCtrl.hidden = false
                self.volCtrl.enabled = true
                
            }
            
        }
        
        if(segCtrl.selectedSegmentIndex == 1){
            //show all in party view elements
            self.friendsInParty.hidden = false
            self.leaveOrEnd.hidden = false
            self.leaveOrEnd.enabled = true
            
            
            if(self.party.role == PeerType.Host_Creator || self.party.role == PeerType.Guest_Creator){
                
                self.addMore.hidden = false
                self.addMore.enabled = true
            }
            
            
            //hide all relevent current playing ui components
            self.songImg.hidden = true
            self.titleLabel.hidden = true
            self.artistAndAlbumLabel.hidden = true
            self.minLabel.hidden = true
            self.maxLabel.hidden = true
            self.progressBar.hidden = true
            
            self.volCtrl.hidden = true
            self.volCtrl.enabled = false
        }
        
    }
    
    //controller data for currently playing segment
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistAndAlbumLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    /*Host Buttons*/
    @IBOutlet var volCtrl: UISlider!
    @IBOutlet var ppfButton: UIButton!
    
    //controller data for in party view
    @IBOutlet var friendsInParty: UICollectionView!
    @IBOutlet var leaveOrEnd: UIButton!
    /*Host Buttons*/
    @IBOutlet var addMore: UIButton!
    
    
    
    //Action Methods for In Party View
    
    //Only visible for host
    @IBAction func inviteMore(sender: UIButton!){
        
    }
    
    //Alternates to either end a party or leave a party depending on host or guest role
    @IBAction func endOrLeaveParty(sender: UIButton){
        
    }
    
    
    //Action Methods for Currently Playing View
    @IBAction func volChng(sender: UISlider){
        self.audioPlayer.volume = sender.value
    }
    @IBAction func playPauseFav(sender: UIButton){
        if (self.party.role == PeerType.Host_Creator || self.party.role == PeerType.Guest_Creator){
            if(playing == true){
                for peer in self.party.session.connectedPeers {
                    var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "pause_stream"]
                    self.party.sendInstruction(dictionary, toPeer: peer as! MCPeerID)
                }
                self.audioPlayer.pause()
                self.playing = false
                self.ppfButton.setBackgroundImage(UIImage(named: "Play-52.png"), forState: UIControlState.Normal)
                
            }else{
                for peer in self.party.session.connectedPeers {
                    var dictionary: [String: String] = ["sender": self.party.myPeerID.displayName, "instruction": "resume_stream"]
                    self.party.sendInstruction(dictionary, toPeer: peer as! MCPeerID)
                }
                self.audioPlayer.play()
                self.playing = true
                self.ppfButton.setBackgroundImage(UIImage(named: "Pause-52.png"), forState: UIControlState.Normal)
                
                
            }
        }
        
    }
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        //set up for in party view
        self.friendsInParty.dataSource = self
        self.friendsInParty.delegate = self
        self.friendsInParty.hidden = true
        self.leaveOrEnd.hidden = true
        self.leaveOrEnd.enabled = false
        
        
        
        //Set up for CurrentlyPlayingView
        self.progressBar.setProgress(0, animated: true)
        self.volCtrl.hidden = true
        self.volCtrl.enabled = false
        
        if(self.party.role == PeerType.Host_Creator || self.party.role == PeerType.Guest_Creator){
            self.volCtrl.hidden = false
            self.volCtrl.enabled = true
            
            self.audioPlayer = AVPlayer(URL: self.party.currentSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL)
            
            self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
            self.titleLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)!
            self.artistAndAlbumLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)! + " - " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!)!
            self.audioPlayer.volume = self.volCtrl.value
            self.maxLabel.text = String(stringInterpolationSegment: self.audioPlayer.currentItem.duration.value)
            self.party.delegate = self
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // Put the calculations here
                
                for peer in self.party.session.connectedPeers {
                    self.party.outputStreamers[peer.displayName]?.start()
                }
                self.audioPlayer.play()
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateLabels"), userInfo: nil, repeats: true)
                
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    // any updates of the UI need to be here to do them in the main thread after your background task. For example adding subviews
                    
                    if (self.party.role == PeerType.Guest_Creator){
                        self.leaveOrEnd.titleLabel!.text = "Leave Party"
                    }
                    
                }
            }
            
            //sets the next host of the party once the party starts
            self.party.chooseNextHost()
            print(self.party.currentHost)
            
            //used to notify for end of song and initiate next host loop
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "songDidEnd:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
            
        }else if (self.party.role == PeerType.Guest_Invited || self.party.role == PeerType.Host_Invited){
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // Put the calculations here
                dispatch_async(dispatch_get_main_queue()) {
                    // any updates of the UI need to be here to do them in the main thread after your background task. For example adding subviews
                    
                    self.volCtrl.hidden = true
                    self.volCtrl.enabled = false
                    
                    self.songImg.image = self.party.currentSongIMG
                    self.titleLabel.text = (self.party.currentSongTitle)
                    println(self.party.currentSongTitle)
                    println(self.titleLabel.text)
                    self.artistAndAlbumLabel.text = (self.party.currentSongArtistAlbum)
                    self.party.delegate = self
                    self.ppfButton.hidden = true
                    
                    if(self.party.role == PeerType.Guest_Invited){
                        self.leaveOrEnd.titleLabel!.text = "Leave Party"
                    }
                    

                    
                }
            }
        }
        
        

    }
    
    override func viewDidAppear(animated: Bool) {
        //make this part check which view to display later
        
        if(self.firstPass){
            self.firstPass = !self.firstPass
        }else{
            viewDidLoad()
        }
        
    }

    func songDidEnd(notification: NSNotification){
        
        if(self.party.role == PeerType.Host_Creator){
            self.party.role == PeerType.Host_Invited
        }else if (self.party.role == PeerType.Guest_Creator){
            self.party.role == PeerType.Guest_Invited
        }
        
        var didAnyoneBecomeHost: Bool = false
        for peer in self.party.connectedPeers() as! [MCPeerID]{
            self.party.outputStreamers[peer.displayName]?.stop()
            
            if ((self.party.currentHost != nil) && (peer.displayName == self.party.currentHost)){
                var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "start_picking_a_song"]
                self.party.sendInstruction(dictionary, toPeer: peer)
                didAnyoneBecomeHost = true
            }else{
                var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "wait_in_nextUp_Scene"]
                self.party.sendInstruction(dictionary, toPeer: peer)
            }
        }
        
        if(didAnyoneBecomeHost){
            self.performSegueWithIdentifier("NextUpSegue", sender: self)
        }else{
            self.performSegueWithIdentifier("NextSongSelectionSegue", sender: self)
        }
        
    }
    
    func timeFormat(value: Float) -> String{
        var minutes: Float = floor(roundf((value)/60))
        println(minutes)
        var seconds: Float = roundf(((minutes * 60)))
        var roundSeconds: Int = Int(roundf(seconds))
        var roundMinutes: Int = Int(roundf(minutes))
        var time: String = String(format: "%d:%02d", roundMinutes, roundSeconds)
        return time
        
    }
    
    func updateLabels(){
        if (self.playing == true){
           // var timeLeft = self.audioPlayer.currentItem.duration.value - self.audioPlayer.currentTime().value
            //var interval = timeLeft
            //var seconds = interval%60
            //println(seconds)
            //var minutes = (interval/60)%60
            //println(minutes)
            self.minLabel.text = self.timeFormat(Float(CMTimeGetSeconds(self.audioPlayer.currentTime())))
            
            println("Time Elapsed:" +  self.timeFormat(Float(CMTimeGetSeconds(self.audioPlayer.currentTime()))))
            
            
            self.maxLabel.text = self.timeFormat((Float(CMTimeGetSeconds(self.audioPlayer.currentItem.duration)) - Float(CMTimeGetSeconds(self.audioPlayer.currentTime()))))
            
            println("Time Left:" + self.timeFormat((Float(CMTimeGetSeconds(self.audioPlayer.currentItem.duration)) - Float(CMTimeGetSeconds(self.audioPlayer.currentTime())))))
            
            //updates progressBar
            var normalizedTime = Float((Float(CMTimeGetSeconds(self.audioPlayer.currentTime())) * 100.0)/Float(CMTimeGetSeconds(self.audioPlayer.currentItem.duration)))
            self.progressBar.setProgress(normalizedTime, animated: true)
            
            
            
            
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
        
        if segue.identifier == "NextUpSegue" {
            let vc: NextUpViewController = (segue.destinationViewController as? NextUpViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
            
            
        }
        if segue.identifier == "NextSongSelectionSegue" {
        
            let vc: SongSelectionViewController = (segue.destinationViewController as? SongSelectionViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
            
            
            
            
            
        }
    }
    

}

//collection view methods
extension CurrentlyPlayingViewController {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: InvitedCollectionViewCell! = self.friendsInParty.dequeueReusableCellWithReuseIdentifier("InvitedCollectionCell", forIndexPath: indexPath) as! InvitedCollectionViewCell
        if(indexPath.row == 0){
            cell.friendImage.image = self.usr[0].profileImg.image!
        }
        else if((indexPath.row > 0) && (indexPath.row <= self.party.invitedFriends.count)){
            let friend = self.party.invitedFriends[indexPath.row - 1]
            if friend.profileImg == nil {
                cell.friendImage.backgroundColor = UIColor.lightGrayColor()
            }
            else{
                cell.friendImage.image = friend.profileImg.image!
            }
            
            
        }else{
            
            cell.friendImage.backgroundColor = UIColor.grayColor()
            
        }
        
        //rounds uiimage and configures UIImageView
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.width/2
        cell.friendImage.clipsToBounds = true
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
        
        
    }

}

extension CurrentlyPlayingViewController: UIAlertViewDelegate {

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 0){
            var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "does_accept"]
            self.party.sendInstruction(dictionary, toPeer: curr_fromPeer)
            self.party.currentHost = self.party.myPeerID.displayName
            print(self.party.currentHost)
            alertView.dismissWithClickedButtonIndex(0, animated: true)
        }
        if(buttonIndex == 1){
            var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "does_not_accept"]
            self.party.sendInstruction(dictionary, toPeer: curr_fromPeer)
            alertView.dismissWithClickedButtonIndex(1, animated: true)
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
                
            }else if(instruction == "want_to_be_host"){
                self.curr_fromPeer = fromPeer
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    // Put the calculations here
                    dispatch_async(dispatch_get_main_queue()) {
                        // any updates of the UI need to be here to do them in the main thread after your background task. For example adding subviews
                        
                        if objc_getClass("UIAlertController") != nil {
                            
                            let alert = UIAlertController(title: "Hosting Request", message: "Would you like to be the next host for the party and pick a song?", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Accept", style: .Default, handler:{
                                (action: UIAlertAction!) -> Void in
                                var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "does_accept"]
                                self.party.sendInstruction(dictionary, toPeer: fromPeer)
                                self.party.currentHost = self.party.myPeerID.displayName
                                alert.dismissViewControllerAnimated(true, completion: nil)
                                
                            }))
                            
                            
                            alert.addAction(UIAlertAction(title: "Decline", style: .Default, handler:{
                                (action: UIAlertAction!) -> Void in
                                var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID, "instruction": "does_not_accept"]
                                self.party.sendInstruction(dictionary, toPeer: fromPeer)
                                alert.dismissViewControllerAnimated(true, completion: nil)
                            }))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        }else{
                            let alert = UIAlertView()
                            alert.delegate = self
                            
                            alert.title = "Hosting Rrequest"
                            alert.message = "Would you like to be the next host for the party and pick a song?"
                            alert.addButtonWithTitle("Accept")
                            alert.addButtonWithTitle("Decline")
                            alert.show()
                            
                            }
                            
                            
                        }

                }
            
                
            }else if(instruction == "start_picking_a_song"){
                if(self.party.role == PeerType.Host_Invited){
                    self.party.role == PeerType.Host_Creator
                }
                if(self.party.role == PeerType.Guest_Invited){
                    self.party.role == PeerType.Guest_Creator
                }
                self.performSegueWithIdentifier("NextSongSelectionSegue", sender: self)
            }else if(instruction == "wait_in_nextUp_Scene"){
                self.performSegueWithIdentifier("NextUpSegue", sender: self)
            }
        }
            
        
        
        
    }
    
}
