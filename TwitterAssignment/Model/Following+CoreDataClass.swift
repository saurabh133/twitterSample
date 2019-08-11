//
//  Following+CoreDataClass.swift
//  
//
//  Created by Saurabh Madne on 11/08/19.
//
//

import Foundation
import CoreData

@objc(Following)
public class Following: NSManagedObject {

    class func loadFollowerData(responseData : NSDictionary){
        
        Following.mr_truncateAll()
        Utilities.saveDefaultContext()
        
        let context : NSManagedObjectContext = NSManagedObjectContext.mr_default()
        
        if ((responseData.value(forKey: "users")) != nil)
        {
            let userList = responseData.value(forKey: "users") as! NSArray
            
            for dictObj in userList{
                
                let userData : Following?  = Following.mr_createEntity(in: context)!
                
                if (userData != nil){
                    
                    if (((dictObj as AnyObject).value(forKey: "name")) != nil)
                    {
                        userData?.name = (dictObj as AnyObject).object(forKey: "name") as? String
                    }
                    
                    if (((dictObj as AnyObject).value(forKey: "profile_image_url_https")) != nil)
                    {
                        userData?.profileImageUrl = (dictObj as AnyObject).object(forKey: "profile_image_url_https") as? String
                    }
                    
                    if (((dictObj as AnyObject).value(forKey: "followers_count")) != nil)
                    {
                        userData?.followingCount = ((dictObj as AnyObject).object(forKey: "followers_count") as? Int64)!
                    }
                    
                    if (((dictObj as AnyObject).value(forKey: "screen_name")) != nil)
                    {
                        userData?.screenName = (dictObj as AnyObject).object(forKey: "screen_name") as? String
                    }
                }
                
                Utilities.saveDefaultContext()
            }
             
        }
    }
    
    class func getFollowing() -> NSArray?{
        
        let followersList : NSArray = Following.mr_findAll() as! NSArray
        
        return followersList
    }
}
