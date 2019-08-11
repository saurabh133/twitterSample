//
//  UserDetails+CoreDataProperties.swift
//  
//
//  Created by Saurabh Madne on 10/08/19.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var followersCount: Int64
    @NSManaged public var followingCount: Int64
    @NSManaged public var lastname: String?
    @NSManaged public var userEmail: String?
    @NSManaged public var userName: String?
    @NSManaged public var userPhoto: String?

}
