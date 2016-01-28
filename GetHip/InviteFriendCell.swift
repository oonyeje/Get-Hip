//
//  InviteFriendCell.swift
//  GetHip
//
//  Created by Okechi on 1/23/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class InviteFriendCell: UITableViewCell {
    
    @IBOutlet var friendName: UILabel!
    
    @IBOutlet var proImage: UIImageView!
    
    @IBOutlet var rdioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
