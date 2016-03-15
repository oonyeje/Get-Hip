//
//  FriendData.swift
//  GetHip
//
//  Created by Okechi on 1/13/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation

class FriendData: NSObject, NSCoding {
    var displayName: String!
    var profileImg: UIImageView!
    var status: String!
    var username: String!
    
    init(display: String, status: String, username: String){
        self.displayName = display
        self.profileImg = nil
        self.status = status
        self.username = username
        super.init()
        
    }
    

    //MARK: NSCoding
    required init(coder aDecoder: NSCoder){
        self.displayName = aDecoder.decodeObjectForKey("displayName") as! String
        self.profileImg = aDecoder.decodeObjectForKey("profileImg") as! UIImageView!
        self.status = aDecoder.decodeObjectForKey("status") as! String
        self.username = aDecoder.decodeObjectForKey("username") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.displayName, forKey: "displayName")
        aCoder.encodeObject(self.profileImg, forKey: "profileImg")
        aCoder.encodeObject(self.status, forKey: "status")
        aCoder.encodeObject(self.username, forKey: "username")
    }
    
    //Mark: NSObject
    
    override func isEqual(object: AnyObject?) -> Bool{
        if let object = object as? FriendData {
            return self.displayName == object.displayName
                && self.profileImg == object.profileImg
                && self.status == object.status
                && self.username == object.username
        }else {
            return false
        }
    }
    
    override var hash: Int {
        return self.displayName.hashValue
    }
}
