//
//  FriendListViewController.swift
//  TwitterAssignment
//
//  Created by Saurabh Madne on 10/08/19.
//  Copyright © 2019 Saurabh Mjecadne. All rights reserved.
//

import UIKit
import SDWebImage

class FriendListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    var isForFollowers:Bool = false
    var fetchIsInprogress = false
    var screenName:String?
    var accessToken:String?
    var pagingValue:String = "-1"
    var preValue:String = "-1"
    var followersTotalCount:Int = 0
    var pageValueCount =  20

    
    var listBindingArray:NSMutableArray = NSMutableArray()
    var userDetailsDict:NSMutableDictionary = NSMutableDictionary()
   
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.updatedUI()
        self.getFollowers()
    }
    
    func updatedUI()
    {
        self.title = isForFollowers ? FRIEND_LIST_FOLLOWERS_TITLE : FRIEND_LIST_FOLLOWING_TITLE
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "xmark"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(dissmissView))
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func dissmissView()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getFollowers()
    {
         let skipStatus = TRUE_V
         let includeUserEntities = FALSE_V
         self.fetchIsInprogress = true
         
         userDetailsDict.setValue(pagingValue.description, forKey: "cursor")
         userDetailsDict.setValue(pageValueCount, forKey: "count")
         userDetailsDict.setValue(self.screenName, forKey: "screen_name")
         userDetailsDict.setValue(skipStatus, forKey: "skip_status")
         userDetailsDict.setValue(includeUserEntities, forKey: "include_user_entities")
         userDetailsDict.setValue(self.accessToken, forKey: "secretKey")
        
        var friendlistURL = ""
        
        if isForFollowers{
          friendlistURL = GET_FOLLOWERS_LIST
        }else{
          friendlistURL = GET_FRIENDS_LIST
        }
        
        Utilities.startActivityIndicator(activity: self.activityIndicator)
        
        ConnectionManager.callGetMethodWith(url: friendlistURL, appenDict: userDetailsDict) { (data, response, error) in
         
         if error != nil {
         print(error!.localizedDescription)
         } else {
         do {
         if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
         {
            self.fetchIsInprogress = false
            
            if ((json.value(forKey: "users")) != nil)
            {
                if (json.value(forKey: "next_cursor_str") != nil)
                {
                    self.pagingValue = json.value(forKey: "next_cursor_str") as! String
                }
                
                if (json.value(forKey: "previous_cursor_str") != nil)
                {
                    self.preValue = json.value(forKey: "previous_cursor_str") as! String
                }
                
                
                if self.isForFollowers
                    {
                        DispatchQueue.main.async {
                            Follower.loadUserData(responseData:json )
                        }
                    }else{
                        DispatchQueue.main.async {
                            Following.loadFollowerData(responseData: json )
                        }
                    }
                
                self.reloadTableViewAfterFetch()
            }
         }
         } catch {
         print("error in JSONSerialization")
         }
         }
         }
     }
    
    func reloadTableViewAfterFetch()
    {
        listBindingArray.removeAllObjects()
        
        if self.isForFollowers
        {
            let friendArray = Follower.getFollowersList()
            listBindingArray = friendArray?.mutableCopy() as! NSMutableArray
        }else{
            
            let friendArray = Following.getFollowing()
            listBindingArray = friendArray?.mutableCopy() as! NSMutableArray
        }
        
        Utilities.stopActivityIndicator(activity: self.activityIndicator)
    
       
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    //MARK:TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return listBindingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as! FriendTableViewCell
        
         cell.selectionStyle = .none
        
        if listBindingArray.count > 0
        {
            if self.isForFollowers{
                
                cell.updatedCellFollwerDetails(orderObj: ((listBindingArray[indexPath.row] as? Follower)!))
                
            }else{
                cell.updatedCellFollowingDetails(orderObj: (listBindingArray[indexPath.row] as? Following)!)
            }
        }
         
        cell.layoutSubviews()
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    //MARK:Scrollview Delegate Methods
  
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
   
        if listBindingArray.count < followersTotalCount && !fetchIsInprogress
        {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
            
            if (((tableview.contentOffset.y + tableview.frame.size.height) > tableview.contentSize.height )) && pagingValue != "0"{
                
                self.getFollowers()
                
            }else if translation.y > 0  && preValue != "0"{
                self.pagingValue = self.preValue
                 self.getFollowers()
            }
        
        }
    }

}
