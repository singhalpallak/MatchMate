//
//  StoredProfileData+CoreDataProperties.swift
//  MatchMate
//
//  Created by Singhal, Pallak on 27/09/25.
//
//

import Foundation
import CoreData


extension StoredProfileData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredProfileData> {
        return NSFetchRequest<StoredProfileData>(entityName: "StoredProfileData")
    }

    @NSManaged public var age: Int16
    @NSManaged public var displayLocation: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: String?
    @NSManaged public var pictureURL: String?
    @NSManaged public var status: String?

}

extension StoredProfileData : Identifiable {

}
