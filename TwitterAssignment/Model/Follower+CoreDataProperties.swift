//
//  Follower+CoreDataProperties.swift
//  
//
//  Created by Saurabh Madne on 11/08/19.
//
//

import Foundation
import CoreData


extension Follower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Follower> {
        return NSFetchRequest<Follower>(entityName: "Follower")
    }

    @NSManaged public var follwersCount: Int64
    @NSManaged public var name: String?
    @NSManaged public var profileImageUrl: String?
    @NSManaged public var screenName: String?

}
