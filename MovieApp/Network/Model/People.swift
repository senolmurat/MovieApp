//
//  People.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import Foundation

// MARK: - People
struct People: Codable {
    let birthday: String?
    let knownForDepartment: String
    let deathday: String?
    let id: Int
    let name: String
    let alsoKnownAs: [String]
    let gender: Int
    let biography: String
    let popularity: Double
    let placeOfBirth: String?
    let profilePath: String?
    let adult: Bool
    let imdbID: String
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case birthday = "birthday"
        case knownForDepartment = "known_for_department"
        case deathday = "deathday"
        case id = "id"
        case name = "name"
        case alsoKnownAs = "also_known_as"
        case gender = "gender"
        case biography = "biography"
        case popularity = "popularity"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult = "adult"
        case imdbID = "imdb_id"
        case homepage = "homepage"
    }
}
