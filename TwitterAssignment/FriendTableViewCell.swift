//
//  FriendTableViewCell.swift
//  TwitterAssignment
//
//  Created by Saurabh Madne on 10/08/19.
//  Copyright © 2019 Saurabh Mjecadne. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet var lbluserName: UILabel!
    @IBOutlet var imageViewFriend: UIImageView!
    @IBOutlet var lblFollowerscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updatedCellFollwerDetails(orderObj:Follower)
    {
        if (orderObj.name != nil)
        {
            self.lbluserName.text = orderObj.name
            self.lblFollowerscount.text = orderObj.follwersCount.description
            
            if (orderObj.profileImageUrl != nil)
            {
                self.imageViewFriend.sd_setImage(with: URL(string: orderObj.profileImageUrl!), placeholderImage: UIImage(named: "profile.png"))
            }
        }
    }
    
    func updatedCellFollowingDetails(orderObj:Following)
    {
        if (orderObj.name != nil) {
            
            self.lbluserName.text = orderObj.name
            self.lblFollowerscount.text = orderObj.followingCount.description
            
            if (orderObj.profileImageUrl != nil)
            {
                self.imageViewFriend.sd_setImage(with: URL(string: orderObj.profileImageUrl!), placeholderImage: UIImage(named: "profile.png"))
            }
        }

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
