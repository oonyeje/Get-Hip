//
//  HomeScreenViewController.swift
//  GetHip
//
//  Created by Okechi on 1/3/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    var usrDataManager = UserParseDataSource()
    var frndDataManager = FriendDataSource()
    var friendData: [FriendData] = []
    var requestData: [FriendData] = []
    var userData: [UserParseData] = []
    let partyData = PartyServiceManager()
    
    @IBOutlet weak var CreateAPartyBtn: UIButton!
    
    
    //async data update methods
    func refreshFriendData(notification:NSNotification){
        
        let friendInfo = self.frndDataManager.getFriends()
        
        for pendingFriend in friendInfo {
            if pendingFriend.status == "pending"{
                self.requestData.append(pendingFriend)
            }else{
                self.friendData.append(pendingFriend)
            }
        }
    }
    
    func refreshUserData(notification:NSNotification){
        self.userData = self.usrDataManager.getUser()
        
        self.partyData.setPeerID((self.userData[0].displayName))
        self.partyData.setAdvertiser()
    }
    
    func loadID(notification: NSNotification){
        self.performSegueWithIdentifier("InviteFriendsSegue", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        CreateAPartyBtn.layer.cornerRadius = 5
        CreateAPartyBtn.layer.borderWidth = 1
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadID:", name: "gotDisplayID", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshFriendData:", name: "refreshTableView", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserData:", name: "refreshSettingsView", object: nil)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InviteFriendsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: TestInviteFriendsController = (nav.viewControllers[0] as? TestInviteFriendsController)!
            
            //initialize host role
            self.partyData.setRole(PeerType(rawValue: 0)!)
            
            //initialize browser to find nearby friends
            self.partyData.setBrowser()
            
            //initialize session
            self.partyData.initializeSession()
            
            vc.setData(self.userData, frndData: self.friendData, party: self.partyData)
        }
        
        if segue.identifier == "SettingsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: SettingsTableViewController = (nav.viewControllers[0] as? SettingsTableViewController)!
            vc.setData(self.userData)
        }
        
        if segue.identifier == "FriendListSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: FriendsListViewController = (nav.viewControllers[0] as? FriendsListViewController)!
            vc.setData(self.friendData, requst: self.requestData)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
