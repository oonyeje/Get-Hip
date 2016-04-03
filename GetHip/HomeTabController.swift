//
//  HomeTabController.swift
//  GetHip
//
//  Created by Okechi on 4/2/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {

    var usrDataManager: UserParseDataSource!
    var frndDataManager: FriendDataSource!
    var friendData: [FriendData] = []
    var requestData: [FriendData] = []
    var userData: [UserParseData] = []
    let partyData = PartyServiceManager()
    var firstTime: Bool = true
    private var firstTimeBrowsing: Bool = true
    //@IBOutlet weak var CreateAPartyBtn: UIButton!
    
    
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
        
        //start browsing for peers
        self.partyData.setBrowser()
        self.partyData.startBrowser()
        
        //self.partyData.delegate = self
        self.firstTime = false
        
        
    }
    
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
            //self.firstTime = false
        }
        
        self.frndDataManager = FriendDataSource()
    }
    
    func loadID(notification: NSNotification){
        self.performSegueWithIdentifier("InviteFriendsSegue", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        //CreateAPartyBtn.layer.cornerRadius = 5
        //CreateAPartyBtn.layer.borderWidth = 1
        //self.tabBarController?.delegate = self
        //self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadID:", name: "gotDisplayID", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshFriendData:", name: "refreshTableView", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserData:", name: "refreshSettingsView", object: nil)
        
        self.userData = []
        self.friendData = []
        dispatch_async(dispatch_get_main_queue(), {
            self.usrDataManager = UserParseDataSource()
            //self.frndDataManager = FriendDataSource()
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

