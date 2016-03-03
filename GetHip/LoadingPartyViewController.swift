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
    var timer = NSTimer()
    var counter = 60
    
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
        
        // Do any additional setup after loading the view.
        self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
        self.songLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)! + " by " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)!
        
        //sets up timer label and starts countdown to next screen
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateThumbnail:", name: "peerConnected", object: nil)
        self.timerLabel.text = String(counter)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateThumbnil(notification: NSNotification){
        
    }
    
    func updateCounter(){
        self.timerLabel.text = String(counter--)
        if(self.counter == -1){
            self.timer.invalidate()
            self.performSegueWithIdentifier("CurrentlyPlayingSegue", sender: nil)
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
        cell.alpha = 0.5
        
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
        println(self.party.myPeerID.displayName + " connected to " + peerID.displayName)
        var i = 0
        for(index, aFriend) in enumerate(self.party.invitedFriends) {
            if aFriend.displayName == peerID.displayName {
                i = index
                break
            }
        }
        
        let cell: InvitedCollectionViewCell = self.invitedFriends.dequeueReusableCellWithReuseIdentifier("InvitedCollectionCell", forIndexPath: NSIndexPath(index: i)) as! InvitedCollectionViewCell
        
        cell.alpha = 1.0
        
        
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
        //extract data from dictionary
        println("mark 3")
        let data = dictionary["data"] as? NSData
        let fromPeer = dictionary["fromPeer"] as! MCPeerID
        
        //convert data to dictionary object with instruction
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, String>
        
        //check if this is an instruction being sent
        if let instruction = dataDictionary["instruction"] {
            println(instruction)
        }
    }
    
}