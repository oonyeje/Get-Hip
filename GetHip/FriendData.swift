//
//  FriendData.swift
//  GetHip
//
//  Created by Okechi on 1/13/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation

class FriendData {
    var displayName: String!
    var profileImg: UIImage!
    var status: String!
    
    init(display: String, status: String){
        self.displayName = display
        self.profileImg = nil
        self.status = status
        
    }
    

}
