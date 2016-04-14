//
//  HomeScreenViewController.swift
//  GetHip
//
//  Created by Okechi on 1/3/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HomeScreenViewController: UIViewController, PartyServiceManagerDelegate {
    var usrDataManager: UserParseDataSource!
    var frndDataManager: FriendDataSource!
    var friendData: [FriendData] = []
    var requestData: [FriendData] = []
    var userData: [UserParseData] = []
    var partyData: PartyServiceManager! //= PartyServiceManager()
    var firstTime: Bool = true
    private var firstTimeBrowsing: Bool = true
    @IBOutlet weak var CreateAPartyBtn: UIButton!
    
    
    //async data update methods
    /*
    func refreshFriendData(notification:NSNotification){
        
        let friendInfo = self.frndDataManager.getFriends()
        
        for pendingFriend in friendInfo {
            if pendingFriend.status == "pending"{
                self.requestData.append(pendingFriend)
            }else{
                self.friendData.append(pendingFriend)
            }
        }
        
        //start browsing for peers
        self.partyData.setBrowser()
        self.partyData.startBrowser()
        
        //self.partyData.delegate = self
        self.firstTime = false
        
        
    }
*/
    /*
    func refreshUserData(notification:NSNotification){
        
        self.userData = self.usrDataManager.getUser()
        
        if(self.firstTime == true){
            self.partyData.setPeerID((self.userData[0].displayName))
            self.partyData.initializeSession()
            
            //start peer-to-peer advertising
            self.partyData.setAdvertiser()
            self.partyData.startListening()
            
            //start browsing for peers
            //self.partyData.setBrowser()
            //self.partyData.startBrowser()
            
            self.partyData.delegate = self
            //self.firstTime = false
        }
        
        self.frndDataManager = FriendDataSource()        
    }
    */
    
    /*
    func loadID(notification: NSNotification){
        self.performSegueWithIdentifier("InviteFriendsSegue", sender: nil)
    }
    */
    
    func listenForData(notification: NSNotification){
        self.userData = (self.tabBarController as? HomeTabController)!.userData
        self.partyData = (self.tabBarController as? HomeTabController)!.partyData
        self.friendData = (self.tabBarController as? HomeTabController)!.friendData
        self.requestData = (self.tabBarController as? HomeTabController)!.requestData
        self.partyData.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //for sharing data with tab bar navigations
        //var vc = self.tabBarController as? HomeTabController
        //self.userData = (self.tabBarController as? HomeTabController)!.userData
        //self.partyData = (self.tabBarController as? HomeTabController)!.partyData
        //self.friendData = (self.tabBarController as? HomeTabController)!.friendData
        //self.requestData = (self.tabBarController as? HomeTabController)!.requestData
        
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor.whiteColor()
        CreateAPartyBtn.layer.cornerRadius = 5
        CreateAPartyBtn.layer.borderWidth = 1
        //self.tabBarController?.delegate = self
        //self.navigationController?.navigationBarHidden = true
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadID:", name: "gotDisplayID", object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshFriendData:", name: "refreshTableView", object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserData:", name: "refreshSettingsView", object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "listenForData:", name: "dataMark", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
        self.userData = []
        self.friendData = []
        dispatch_async(dispatch_get_main_queue(), {
            self.usrDataManager = UserParseDataSource()
            //self.frndDataManager = FriendDataSource()

        })
*/
        
    }

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
            
            //remove fake peers that would appear in list if a peer that is found disconnects before entering invite screen
    
                
            
            
            
            
            vc.setData(self.userData, frndData: self.friendData, party: self.partyData, request: self.requestData)
        }
        
        if segue.identifier == "SettingsSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: SettingsTableViewController = (nav.viewControllers[0] as? SettingsTableViewController)!
            
            //vc.setData(self.userData, prty: self.partyData, frends: self.friendData, request: self.requestData)
        }
        
        if segue.identifier == "FriendListSegue" {
            let nav: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            
            let vc: FriendsListViewController = /*segue.destinationViewController as! FriendsListViewController */(nav.viewControllers[0] as? FriendsListViewController)!
            vc.setData(self.friendData, requst: self.requestData, party: self.partyData, user: self.userData)
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
/*
extension HomeScreenViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController .isKindOfClass(SettingsTableViewController) {
        
            let vc: SettingsTableViewController = (viewController as? SettingsTableViewController)!
            vc.setData(self.userData, prty: self.partyData, frends: self.friendData, request: self.requestData)
            
        }else if(viewController .isKindOfClass(FriendsListViewController)){
            
            let vc: FriendsListViewController = (viewController as? FriendsListViewController)!
            vc.setData(self.friendData, requst: self.requestData, party: self.partyData, user: self.userData)
            
        }
    }
}
*/
extension HomeScreenViewController: PartyServiceManagerDelegate {
    func foundPeer() {
        if(self.firstTimeBrowsing == true){
            //used for finding nearby friends when starting a party
            for i in 0..<self.friendData.count{
                self.partyData.isInvitable.append(false)
            }
            self.firstTimeBrowsing = false
        }
        
        for foundPeer in self.partyData.foundPeers {
            for friend in self.friendData {
                if foundPeer.displayName == friend.displayName {
                    for(index, aFriend) in enumerate(self.friendData) {
                        if aFriend.displayName == friend.displayName {
                            self.partyData.isInvitable[index] = true
                            self.partyData.invitableCount++
                            
                            break
                        }
                    }
                }
            }
        }
    }
    
    func lostPeer() {
        
    }
    
    func invitationWasRecieved(peerID: MCPeerID, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: InvitedToPartyViewController = storyboard.instantiateViewControllerWithIdentifier("InvitedToPartyVC") as! InvitedToPartyViewController!
        vc.setData(self.partyData, user: self.userData, friends: self.friendData, request: self.requestData, invHand: invitationHandler, fromPeer: peerID)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
    }
    
    func didRecieveInstruction(dictionary: Dictionary<String, AnyObject>){
    
    }
}



