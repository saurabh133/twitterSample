//
//  UserDetails+CoreDataClass.swift
//
//
//  Created by Saurabh Madne on 09/08/19.
//
//

import Foundation
import CoreData
import MagicalRecord

@objc(UserDetails)
public class UserDetails: NSManagedObject {
    
    class func loadUserData(responseData : NSDictionary){
        
        UserDetails.mr_truncateAll()
        Utilities.saveDefaultContext()
        
        let context : NSManagedObjectContext = NSManagedObjectContext.mr_default()
        
        let userData : UserDetails?  = UserDetails.mr_createEntity(in: context)!
        
        if (userData != nil){
            
            if ((responseData.value(forKey: "screen_name")) != nil)
                {
                     userData?.userName = responseData.object(forKey: "screen_name") as? String
                }

            if ((responseData.value(forKey: "name")) != nil)
                {
                    userData?.firstname = responseData.object(forKey: "name") as? String
                }
                
            if ((responseData.value(forKey: "profile_image_url_https")) != nil)
                {
                    userData?.userPhoto = responseData.object(forKey: "profile_image_url_https") as? String
                }
                
            if ((responseData.value(forKey: "followers_count")) != nil)
                {
                     userData?.followersCount = (responseData.object(forKey: "followers_count") as? Int64)!
                }
                
            if ((responseData.value(forKey: "friends_count")) != nil)
                {
                    userData?.followingCount = (responseData.object(forKey: "friends_count") as? Int64)!
                }
                
            Utilities.saveDefaultContext()
            
        }
    }
    
    class func getUserDetailsWithScreenName(screenName : String) -> UserDetails?{
        
        let predicate : NSPredicate = NSPredicate(format: "userName == %@", screenName)
        let productCategoryDataArray : NSArray = UserDetails.mr_findAll(with: predicate)! as NSArray
        
        if productCategoryDataArray.count > 0 {
            return productCategoryDataArray.firstObject as? UserDetails
        }else{
            return nil
        }
    }
}
