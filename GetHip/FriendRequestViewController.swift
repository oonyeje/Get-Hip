//
//  FriendRequestViewController.swift
//  GetHip
//
//  Created by Okechi on 1/29/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController{
    var searchedEmail: String! //contains the searched email address by user
    var frnds: [String]! //holds email addresses of current users friends
    var party: PartyServiceManager!
    
    @IBOutlet var displayImage: UIImageView!
    @IBOutlet var foundName: UILabel!
    @IBOutlet var sendRequest: UIButton!
    @IBOutlet var searchBar: UITextField!
    
    @IBAction func sendButtonClicked(sender: AnyObject){
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: self.searchedEmail!)
        dispatch_async(dispatch_get_main_queue(),{
            query.getFirstObjectInBackgroundWithBlock({
                (object:PFObject?, error: NSError?) -> Void in
                
                //make friend request object for current user
                var friendRequest:PFObject = PFObject(className: "FriendRequest")
                friendRequest.setObject(PFObject(withoutDataWithClassName: "_User", objectId: (object!.objectId)!), forKey: "OtherUser")
                friendRequest.setObject(PFObject(withoutDataWithClassName: "_User", objectId: PFUser.currentUser()?.objectId!), forKey: "FromUser")
                friendRequest.setObject(PFUser.currentUser()?.username as String!, forKey: "username")
                friendRequest.setObject(object!.objectForKey("username")!, forKey: "inRealtionTo")
                friendRequest.setObject("Awaiting Response", forKey: "RequestStatus")
                friendRequest.save()
                
                PFUser.currentUser()?.relationForKey("FriendRequest").addObject(friendRequest)
                
                //make friend request object for other user
                var otherFriendRequest:PFObject = PFObject(className: "FriendRequest")
                otherFriendRequest.setObject(PFObject(withoutDataWithClassName: "_User", objectId: (object!.objectId)!), forKey: "FromUser")
                otherFriendRequest.setObject(PFObject(withoutDataWithClassName: "_User", objectId: PFUser.currentUser()?.objectId!), forKey: "OtherUser")
                otherFriendRequest.setObject(object!.objectForKey("username")!, forKey: "username")
                otherFriendRequest.setObject(PFUser.currentUser()?.username as String!, forKey: "inRealtionTo")
                otherFriendRequest.setObject("pending", forKey: "RequestStatus")
                otherFriendRequest.save()
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    PFUser.currentUser()!.saveInBackgroundWithBlock({
                        (succeeded, error) -> Void in
                        
                        if(succeeded){
                            
                            //for ios 7 and lower compatibility
                            
                            if objc_getClass("UIAlertController") != nil {
                                
                                var alert = UIAlertController(title: "Request Sent!", message: "Your friend request was sent successfully!", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                            }else{
                                let alert = UIAlertView()
                                alert.title = "Request Sent!"
                                alert.message = "Your friend request was sent successfully!"
                                alert.addButtonWithTitle("OK")
                                alert.show()
                            }
                            
                            println(friendRequest.objectId!)
                            var params = NSMutableDictionary()
                            params.setObject((object!.objectForKey("username") as! String!), forKey: "otherUser")
                            
                            PFCloud.callFunctionInBackground("alertPotentialFriend", withParameters: params as [NSObject : AnyObject])
                            //var params = NSMutableDictionary()
                            //params.s
                            //var param = ["friendRequest" : friendRequest.objectId!]
                           /*
                            PFCloud.callFunctionInBackground("addFriendToFriendRelation", withParameters: params as [NSObject : AnyObject]){
                                (response, error) -> Void in
                                if(error == nil){
                                    println(response as! String)
                                }else{
                                    println(error)
                                }
                                
                            }*/
                            /*PFCloud.callFunctionInBackground("hello", withParameters: nil){
                            (response, error) -> Void in
                                println(response as! String)
                            }*/
                        }
                    })
                })
                
            })
        })
        
    }
    
    @IBAction func buttonClicked(sender: AnyObject){
        searchBar.resignFirstResponder();
        
    }
    
    func setData(friends: [String], party: PartyServiceManager){
        self.frnds = friends
        self.party = party
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.displayImage.layer.cornerRadius = self.displayImage.frame.size.width/2
        self.displayImage.clipsToBounds = true
        
        self.sendRequest.enabled = false
        self.sendRequest.tintColor = UIColor.grayColor()
        
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

extension FriendRequestViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        println("Textfield did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var inFriendsList: Bool = false
        
        
            
            //case where user display name is entered
        	self.searchedEmail = searchBar.text
            
            for email in self.frnds{
                if email == self.searchedEmail{
                    inFriendsList = true
                    break
                }
            }
            
            if(self.searchedEmail == (self.tabBarController as! HomeTabController).userData[0].email){
                

                
                //for ios 7 and lower compatibility
                if objc_getClass("UIAlertController") != nil {
                
                    
                    let alert = UIAlertController(title: "That's You!", message: "Sorry, you can't send a request to yourself.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertView()
                    alert.title = "That's You!"
                    alert.message = "Sorry, you can't send a request to yourself."
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
                
                
                
            }
            else if(inFriendsList == false){
                
                var checkRelation: PFRelation! = PFUser.currentUser()?.relationForKey("FriendRequest")
                var checkQuery = checkRelation.query().whereKey("RequestStatus", equalTo: "Awaiting Response")
                
                checkQuery.whereKey("inRealtionTo", equalTo: self.searchedEmail)
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    checkQuery.getFirstObjectInBackgroundWithBlock({
                        (object, error) -> Void in
                        
                        //put in the checking code after lab today
                        if object == nil {
                            var query = PFQuery(className: "_User")
                            query.whereKey("username", equalTo: self.searchedEmail)
                            
                            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                                query.getFirstObjectInBackgroundWithBlock({
                                    (object: PFObject?, error: NSError?) -> Void in
                                    if(error == nil){
                                        self.foundName.text = object?.objectForKey("displayName") as? String
                                        
                                        //download profile imge
                                        var img = object!.objectForKey("profilePicture")! as? PFFile
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            img!.getDataInBackgroundWithBlock({
                                                (imgData, error) -> Void in
                                                
                                                var downloadedImg = UIImage(data: imgData!)
                                                self.displayImage.image = downloadedImg
                                            })
                                        })
                                        
                                        self.sendRequest.enabled = true
                                    }else{
                                        self.foundName.text = "No Friend Found :("
                                        self.sendRequest.enabled = false
                                    }
                                })
                            })
                            
                        }else{
                            
                            //for ios 7 and lower compatibility
                            
                            if objc_getClass("UIAlertController") != nil {
                                let alert = UIAlertController(title: "Request Already Made!", message: "You have already sent a friend request to this user.", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                                self.presentViewController(alert, animated: true, completion: nil)

                                
                            }else{
                                let alert = UIAlertView()
                                alert.title = "Request Already Made!"
                                alert.message = "You have already sent a friend request to this user."
                                alert.addButtonWithTitle("OK")
                                alert.show()
                            }
                            
                                                    }
                        
                    })
                })
                
            }else{
                
                //for ios 7 and lower compatibility
                
                if objc_getClass("UIAlertController") != nil {
                    let alert = UIAlertController(title: "Already Friends!", message: "You are already friends with this user!", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action:  UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                    self.presentViewController(alert, animated: true, completion: nil)

                    
                }else{
                    let alert = UIAlertView()
                    alert.title = "Already Friends!"
                    alert.message = "You are already friends with this user!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
                
                
            }

        
        
        
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
        
    }
}
