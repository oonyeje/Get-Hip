//
//  LoadingPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 2/8/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MediaPlayer

class LoadingPartyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    var party: PartyServiceManager!
    
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var invitedFriends: UICollectionView!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
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
        
        // Do any additional setup after loading the view.
        self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
        self.songLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)! + " by " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)!
        
        //sets up timer label and starts countdown to next screen
        self.timerLabel.text = String(counter)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCounter(){
        self.timerLabel.text = String(counter--)
        if(self.counter == -2){
            self.timer.invalidate()
            self.performSegueWithIdentifier("CurrentlyPlayingSegue", sender: nil)
        }
    }
    
    func setData(prty: PartyServiceManager){
        self.party = prty
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
        //cell!.proImage.layer.borderWidth = 3.0
        //cell!.proImage.clipsToBounds = true
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.width/2
        cell.alpha = 0.5
        //cell!.proImage.layer.borderColor = UIColor.whiteColor().CGColor
        //cell!.proImage.layer.masksToBounds = true
        
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
            vc.setData(self.party)
        }
    }
    

}
