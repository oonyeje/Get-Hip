//
//  FriendsCell.swift
//  GetHip
//
//  Created by Okechi on 1/8/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    @IBOutlet var friendName: UILabel!
    
    @IBOutlet var proImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}

class FriendRequestCell: UITableViewCell {
    
    @IBOutlet var requestNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class PendingFriendCell: UITableViewCell {
    @IBOutlet var proImg: UIImageView!
    @IBOutlet var friendName: UILabel!
    @IBOutlet var denyButton: UIButton!
    @IBOutlet var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
