//
//  UserProfile.swift
//  MatchMate
//
//  Created by Singhal, Pallak on 27/09/25.
//

import Foundation

struct APIResponse: Codable {
    let results: [UserProfile]
}

struct UserProfile: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let dob: DOB
    let picture: Picture
    let login: Login

    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }

    struct Location: Codable {
        let city: String
        let state: String
        let country: String
    }
    
    struct DOB: Codable {
        let age: Int
    }

    struct Picture: Codable {
        let large: String
    }

    struct Login: Codable {
        let uuid: String
    }

    var id: String { login.uuid }
    var fullName: String { "\(name.title) \(name.first) \(name.last)" }
    var displayLocation: String { "\(location.city), \(location.state), \(location.country)" }
    var ageString: String { "\(dob.age)" }
}
