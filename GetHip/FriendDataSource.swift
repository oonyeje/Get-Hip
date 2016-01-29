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
        
        let predicate: NSPredicate = NSPredicate(format: "(((RequestStatus = %@) OR (RequestStatus = %@)) AND (username = %@))", argumentArray: ["accepted", "pending",currentUser])
        var friendsQuery: PFQuery = PFQuery(className: "FriendRequest", predicate: predicate)
        
        friendsQuery.includeKey("OtherUser").findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            //print(error)
            
            if error == nil {
                for object in objects! {
                    //var image:UIImage = UIImage()
                    
                    let userName = object.objectForKey("OtherUser")!.objectForKey("username") as! String
                    let requestStatus = object.objectForKey("RequestStatus")! as! String
                    
                    /* let pimage:PFFile = object["profilePicture"] as! PFFile

                    pimage.getDataInBackgroundWithBlock({
                        (imageData, error) -> Void in
                    
                        if !(error != nil) {
                            image = UIImage(data: imageData!)!
                        }
                    })*/
                
                        var newFriend: FriendData = FriendData(display: userName, status: requestStatus)
                        //print(userName)
                        self.dataSource.append(newFriend)
                    
                    
                }
                NSLog("%d", self.dataSource.count)
                
            }
    
            NSNotificationCenter.defaultCenter().postNotificationName("refreshTableView", object: nil)
            
        }
        
        
    }
    
    func getFriends() -> [FriendData]{
        
        return self.dataSource
    }
}
