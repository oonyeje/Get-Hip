//
//  NextUpViewController.swift
//  GetHip
//
//  Created by Okechi on 3/14/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class NextUpViewController: UIViewController {
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    @IBOutlet weak var userImages: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImages.layer.cornerRadius = self.userImages.frame.size.width/2
        self.userImages.clipsToBounds = true
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
