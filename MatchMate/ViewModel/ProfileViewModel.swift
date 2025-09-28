//
//  ProfileViewModel.swift
//  MatchMate
//
//  Created by Singhal, Pallak on 27/09/25.
//

import Foundation
import CoreData

class ProfileViewModel: NSObject {
    private let persistence = PersistenceController.shared
    private let network = NetworkService.shared
    var profiles: [ProfileData] = []
    var onProfilesUpdated: (() -> Void)?

    override init() {
        super.init()
        loadProfiles()
    }

    func loadProfiles() {
        profiles = persistence.fetchStoredProfiles()
        onProfilesUpdated?()
    }

    func refreshData() {
        if Reachability.isConnectedToNetwork() {
            network.fetchUsers { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let users):
                        self?.persistence.saveProfiles(users)
                        self?.loadProfiles()
                    case .failure(let error):
                        print("Fetch error: \(error)")
                    }
                }
            }
        } else {
            print("Offline mode: Showing cached data")
        }
    }

    func numberOfProfiles() -> Int {
        return profiles.count
    }

    func profile(at index: Int) -> ProfileData {
        return profiles[index]
    }

    func updateStatus(for id: String, status: String) {
        persistence.updateStatus(for: id, status: status)
        loadProfiles()
    }
}
