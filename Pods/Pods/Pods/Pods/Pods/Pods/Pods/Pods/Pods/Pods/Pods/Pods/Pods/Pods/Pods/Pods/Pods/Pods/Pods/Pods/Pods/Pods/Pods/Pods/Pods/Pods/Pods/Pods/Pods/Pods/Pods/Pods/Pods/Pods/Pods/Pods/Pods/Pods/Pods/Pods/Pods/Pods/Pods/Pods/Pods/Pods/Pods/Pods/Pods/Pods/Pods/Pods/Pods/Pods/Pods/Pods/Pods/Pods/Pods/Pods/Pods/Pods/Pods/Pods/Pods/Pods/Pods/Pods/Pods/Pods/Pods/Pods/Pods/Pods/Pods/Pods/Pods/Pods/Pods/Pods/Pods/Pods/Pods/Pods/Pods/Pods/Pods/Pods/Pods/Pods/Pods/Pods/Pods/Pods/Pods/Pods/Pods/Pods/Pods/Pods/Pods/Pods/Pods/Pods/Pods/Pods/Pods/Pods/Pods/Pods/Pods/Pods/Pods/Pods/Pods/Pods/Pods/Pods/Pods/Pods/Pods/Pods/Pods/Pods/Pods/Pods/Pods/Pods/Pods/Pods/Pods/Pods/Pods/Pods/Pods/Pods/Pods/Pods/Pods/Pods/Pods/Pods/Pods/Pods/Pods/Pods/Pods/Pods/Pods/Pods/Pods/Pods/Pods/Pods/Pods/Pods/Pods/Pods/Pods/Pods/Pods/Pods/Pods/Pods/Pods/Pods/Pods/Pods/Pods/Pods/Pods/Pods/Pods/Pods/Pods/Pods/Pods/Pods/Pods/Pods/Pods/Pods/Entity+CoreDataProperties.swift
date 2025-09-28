//
//  Entity+CoreDataProperties.swift
//  MatchMate
//
//  Created by Singhal, Pallak on 27/09/25.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var fullName: String?
    @NSManaged public var displayLocation: String?
    @NSManaged public var age: Int16
    @NSManaged public var pictureURL: String?
    @NSManaged public var status: String?

}

extension Entity : Identifiable {

}
