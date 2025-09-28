//
//  PersistenceController.swift
//  MatchMate
//
//  Created by Singhal, Pallak on 27/09/25.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MatchMate") // Must match your .xcdatamodeld file name
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func saveProfiles(_ profiles: [UserProfile]) {
        let context = container.viewContext
        for profile in profiles {
            let stored = ProfileData(context: context)
            stored.id = profile.id
            stored.fullName = profile.fullName
            stored.displayLocation = profile.displayLocation
            stored.age = Int16(profile.dob.age)
            stored.pictureURL = profile.picture.large
            stored.status = "pending"
        }
        do {
            try context.save()
        } catch {
            print("Error saving profiles: \(error)")
        }
    }

    func fetchStoredProfiles() -> [ProfileData] {
        let request: NSFetchRequest<ProfileData> = ProfileData.fetchRequest()
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }

    func updateStatus(for id: String, status: String) {
        let context = container.viewContext
        let request: NSFetchRequest<ProfileData> = ProfileData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let profile = try context.fetch(request).first {
                profile.status = status
                try context.save()
            }
        } catch {
            print("Error updating status: \(error)")
        }
    }
}
