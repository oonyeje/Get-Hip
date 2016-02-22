//
//  InvitedToPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 2/20/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class InvitedToPartyViewController: UIViewController {
    var friendData: [FriendData] = []
    var requestData: [FriendData] = []
    var userData: [UserParseData] = []
    var partyData: PartyServiceManager!
    
    @IBOutlet var img: UIImageView!
    
    @IBAction func declineInvite(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func acceptInvite(sender: UIButton){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(prty:PartyServiceManager, user: [UserParseData], friends: [FriendData], request: [FriendData]){
        self.partyData = prty
        self.userData = user
        self.friendData = friends
        self.requestData = request
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "InvitedToPartySettingsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: SettingsTableViewController = (nav.viewControllers[0] as? SettingsTableViewController)!
            vc.setData(self.userData, prty: self.partyData)
        }
        
        if segue.identifier == "InvitedToPartyFriendsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: FriendsListViewController = (nav.viewControllers[0] as? FriendsListViewController)!
            vc.setData(self.friendData, requst: self.requestData, party: self.partyData)
        }
    }
    
    
    
}