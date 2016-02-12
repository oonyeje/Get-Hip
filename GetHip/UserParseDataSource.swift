//
//  UserParseDataSource.swift
//  GetHip
//
//  Created by Okechi on 1/22/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation

class UserParseDataSource{
    var user: [UserParseData]
    
    init() {
        user = []
        var query = PFUser.query()
        var currentUser = PFUser.currentUser()
        
        query!.whereKey("username", equalTo: (currentUser?.username as String!))
        
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            //print(error)
            if error == nil {
                for object in objects! {
                    var usr: UserParseData
                    
                    var usrName: String!
                    var profileImage: UIImageView
                    var displayName: String
                    var email: String
                    
                    usrName = object.objectForKey("username")! as! String
                    displayName = object.objectForKey("displayName") as! String
                    
                    
                    
                    if displayName.isEmpty {
                        displayName = usrName
                    }
                    
                    email = object.objectForKey("email")! as! String
                    
                    
                     usr = UserParseData(usrName: usrName, dispName: displayName, email: email)
                    
                    var img = object.objectForKey("profilePicture")! as? PFFile
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        img!.getDataInBackgroundWithBlock({
                            (imgData, error) -> Void in
                            
                            var downloadedImg = UIImage(data: imgData!)
                            usr.profileImg = UIImageView(image: downloadedImg)
                        })
                    })
                    
                    self.user.append(usr)
                    //print(userName)
                    
                    
                }
                
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("refreshSettingsView", object: nil)
            
        }
        
        
    }
    
    func getUser() -> [UserParseData]{
        
        return self.user
    }
}

