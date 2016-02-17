//
//  CurrentlyPlayingViewController.swift
//  GetHip
//
//  Created by Okechi on 2/10/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MediaPlayer

class CurrentlyPlayingViewController: UIViewController {
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistAndAlbumLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
    //Host buttons
    @IBOutlet var volCtrl: UISlider!
    @IBOutlet var ppfButton: UIButton!
    @IBAction func playPauseFav(sender: UIButton){
    
    }
    
    
    //Guest buttons
    
    //Regular buttons
    @IBAction func partyView(sender: UIButton){
        self.performSegueWithIdentifier("InPartySegue", sender: self)
    }
    
    @IBAction func backToHome(sender: UIButton){
        self.performSegueWithIdentifier("BackToHomeScreenSegue", sender: self)
    }


    
    var party: PartyServiceManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.songImg.image = self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(songImg.frame.size)
        self.titleLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)!
        self.artistAndAlbumLabel.text = (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)! + " - " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!)!
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(prty: PartyServiceManager){
        self.party = prty
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
            let vc: HomeScreenViewController = (segue.destinationViewController as? HomeScreenViewController)!
            vc.comingFromParty = true
            vc.partyData = self.party
        }
    }
    

}
