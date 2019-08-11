//
//  Following+CoreDataProperties.swift
//  
//
//  Created by Saurabh Madne on 11/08/19.
//
//

import Foundation
import CoreData


extension Following {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Following> {
        return NSFetchRequest<Following>(entityName: "Following")
    }

    @NSManaged public var screenName: String?
    @NSManaged public var profileImageUrl: String?
    @NSManaged public var followingCount: Int64
    @NSManaged public var name: String?

}
