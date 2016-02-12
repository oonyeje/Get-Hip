//
//  InPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 2/11/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class InPartyViewController: UIViewController {
    var party: PartyServiceManager!
    @IBOutlet var friendsInParty: UICollectionView!
    @IBOutlet var AddMore: UIButton!
    @IBOutlet var leaveOrEnd: UIButton!
    
    //Only visible for host
    @IBAction func inviteMore(sender: UIButton!){
    
    }
    
    //Alternates to either end a party or leave a party depending on host or guest role
    @IBAction func endOrLeaveParty(sender: UIButton){
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
