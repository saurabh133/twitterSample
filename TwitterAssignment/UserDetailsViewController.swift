//
//  UserDetailsViewController.swift
//  TwitterAssignment
//
//  Created by Saurabh Madne on 08/08/19.
//  Copyright © 2019 Saurabh Mjecadne. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsViewController: UIViewController {

    var screenName:String?
    var accessToken:String?
    var userEmail:String?
    var isForFollowers:Bool = false
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var imageViewUsername: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblFollowersCount: UILabel!
    @IBOutlet var lblFollowingCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatedRecords()
    }
    
    func updatedRecords()
    {
        if (screenName != nil){
            
            self.title = screenName
            let userDetails:UserDetails = UserDetails.getUserDetailsWithScreenName(screenName:screenName! )!
           
                if let email =  userEmail{
                    self.lblEmail.text = "(\(email))"
                }
            
                DispatchQueue.main.async {
                      self.imageViewUsername.sd_setImage(with: URL(string: userDetails.userPhoto!), placeholderImage: UIImage(named: "profile.png"))
                }
           
                self.lblUsername.text = userDetails.firstname
                self.lblFollowersCount.text = userDetails.followersCount.description
                self.lblFollowingCount.text = userDetails.followingCount.description
            
        }
        
    }
    
    
    @IBAction func didSelectFollowingCount(_ sender: Any) {
          self.isForFollowers = false
          self.movetoFriendList()
    }
    
    @IBAction func didSelectFollowersCount(_ sender: Any) {
         self.isForFollowers = true
         self.movetoFriendList()
    }

    func updateBackButton()
    {
        self.navigationItem.setHidesBackButton(true, animated:false);

        let barButtonItem = UIBarButtonItem(image: UIImage(named: "xmark"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(goback))
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func goback()
    {
      self.navigationController?.popViewController(animated: true)
    }
    
    func movetoFriendList()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendListViewController") as! FriendListViewController
        
        let userDetails:UserDetails = UserDetails.getUserDetailsWithScreenName(screenName:screenName! )!
        
        controller.accessToken = self.accessToken
        controller.screenName = self.screenName
        controller.isForFollowers = self.isForFollowers
        let navFriendView = UINavigationController(rootViewController: controller)
        if isForFollowers{
            controller.followersTotalCount = Int(userDetails.followersCount)
        }else{
            controller.followersTotalCount = Int(userDetails.followingCount)
        }
        self.navigationController?.present(navFriendView, animated: false, completion: nil)
        
    }    
   
}
