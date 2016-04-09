//
//  UserParseData.swift
//  GetHip
//
//  Created by Okechi on 1/22/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation

import Foundation

class UserParseData {
    //var username: String!
    var displayName: String!
    var profileImg: UIImageView!
    var email: String!
    
    
    
    init(dispName: String, email: String){
        //self.username = usrName
        self.profileImg = nil //proImage
        self.displayName = dispName
        self.email = email
    }
}