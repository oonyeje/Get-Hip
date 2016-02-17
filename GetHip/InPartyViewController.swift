//
//  InPartyViewController.swift
//  GetHip
//
//  Created by Okechi on 2/11/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class InPartyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    var party: PartyServiceManager!
    @IBOutlet var friendsInParty: UICollectionView!
    @IBOutlet var AddMore: UIButton!
    @IBOutlet var leaveOrEnd: UIButton!
    
    @IBAction func dismissFriendView(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Only visible for host
    @IBAction func inviteMore(sender: UIButton!){
    
    }
    
    //Alternates to either end a party or leave a party depending on host or guest role
    @IBAction func endOrLeaveParty(sender: UIButton){
    
    }
    
    func setData(prty: PartyServiceManager){
        self.party = prty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.friendsInParty.dataSource = self
        self.friendsInParty.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let friend = self.party.invitedFriends[indexPath.row]
        let cell: InvitedCollectionViewCell = self.friendsInParty.dequeueReusableCellWithReuseIdentifier("InvitedCollectionCell", forIndexPath: indexPath) as! InvitedCollectionViewCell
        
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
        //cell.alpha = 0.5
        //cell!.proImage.layer.borderColor = UIColor.whiteColor().CGColor
        //cell!.proImage.layer.masksToBounds = true
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.party.invitedFriends.count
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
