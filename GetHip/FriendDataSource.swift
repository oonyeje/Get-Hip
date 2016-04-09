//
//  FriendDataSource.swift
//  GetHip
//
//  Created by Okechi on 1/13/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation


class FriendDataSource{
    var dataSource: [FriendData]
    
    init() {
        dataSource = []
        var query = PFUser.query()
        var currentUser: String! = PFUser.currentUser()?.username
        
        //finds pending friend request from main FriendRequest table
        let predicate: NSPredicate = NSPredicate(format: "((RequestStatus = %@) AND (username = %@))", argumentArray: ["pending",currentUser])
        var friendsPendingQuery: PFQuery = PFQuery(className: "FriendRequest", predicate: predicate)
        
        friendsPendingQuery.includeKey("OtherUser").findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            //print(error)
            
            if error == nil {
                for object in objects! {
                    //var image:UIImage = UIImage()
                    
                    let email = object.objectForKey("OtherUser")!.objectForKey("email") as! String
                    println(email)
                    let displayName = object.objectForKey("OtherUser")!.objectForKey("displayName") as! String
                    let requestStatus = object.objectForKey("RequestStatus")! as! String
                    
                    
                    
                    var newFriend: FriendData = FriendData(display: displayName, status: requestStatus, email: email )
                    
                    var img = object.objectForKey("OtherUser")!.objectForKey("profilePicture")! as? PFFile
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        img!.getDataInBackgroundWithBlock({
                            (imgData, error) -> Void in
                            
                            var downloadedImg = UIImage(data: imgData!)
                            newFriend.profileImg = UIImageView(image: downloadedImg)
                        })
                    })
                    //print(userName)
                    self.dataSource.append(newFriend)
                    println(self.dataSource.count)
                    
                }
                NSLog("%d", self.dataSource.count)
                
                //dispatches to the main queue the task of getting users current friends from relational table in Parse
                var friendsRelation: PFRelation! = PFUser.currentUser()?.relationForKey("FriendRequest")
                var friendsQuery = friendsRelation.query().whereKey("RequestStatus", equalTo: "accepted")
                dispatch_async(dispatch_get_main_queue(), {
                
                    friendsQuery.includeKey("OtherUser").findObjectsInBackgroundWithBlock({
                        (objects, error) -> Void in
                        
                        if (error == nil){
                            for object in objects! {
                            
                                let email = object.objectForKey("OtherUser")!.objectForKey("email") as! String
                                println(email)
                                let displayName = object.objectForKey("OtherUser")!.objectForKey("displayName") as! String
                                let requestStatus = object.objectForKey("RequestStatus")! as! String
                                var newFriend: FriendData = FriendData(display: displayName, status: requestStatus, email: email)
                                
                                var img = object.objectForKey("OtherUser")!.objectForKey("profilePicture")! as? PFFile
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    img!.getDataInBackgroundWithBlock({
                                        (imgData, error) -> Void in
                                        
                                        var downloadedImg = UIImage(data: imgData!)
                                        newFriend.profileImg = UIImageView(image: downloadedImg)
                                    })
                                })
                                
                                
                                //print(userName)
                                self.dataSource.append(newFriend)
                                println(self.dataSource.count)
                                
                            }
                            NSNotificationCenter.defaultCenter().postNotificationName("refreshTableView", object: nil)
                        }
                    })
                    
                })
                
                
            }
    
            
            
        }
        
        
    }
    
    func getFriends() -> [FriendData]{
        
        return self.dataSource
    }
}
