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

class CurrentlyPlayingViewController: UIViewController{
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
        if(playing == true){
            self.audioPlayer.pause()
            self.playing = false
            self.ppfButton.setBackgroundImage(UIImage(named: "Play-52.png"), forState: UIControlState.Normal)
            
        }else{
            self.audioPlayer.play()
            self.playing = true
            self.ppfButton.setBackgroundImage(UIImage(named: "Pause-52.png"), forState: UIControlState.Normal)
            
        }
    }
    
    
    //Guest buttons
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.audioPlayer = AVPlayer(URL: self.party.currentSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL)
        
        // Do any additional setup after loading the view.
        self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
        self.titleLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)!
        self.artistAndAlbumLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)! + " - " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!)!
        self.audioPlayer.volume = self.volCtrl.value
        self.maxLabel.text = String(stringInterpolationSegment: self.audioPlayer.currentItem.duration.value)
        self.audioPlayer.play()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateLabels"), userInfo: nil, repeats: true)

    }

    func updateLabels(){
        var timeLeft = self.audioPlayer.currentItem.duration.value - self.audioPlayer.currentTime().value
        var interval = timeLeft
        var seconds = interval%60
        println(seconds)
        var minutes = (interval/60)%60
        println(minutes)
        //self.maxLabel.text
        //self.minLabel.text
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
