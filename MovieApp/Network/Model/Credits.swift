//
//  Credits.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import Foundation

// MARK: - Credits
struct Credits: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cast = "cast"
        case crew = "crew"
    }
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int
    let character: String
    let creditID: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character = "character"
        case creditID = "credit_id"
        case order = "order"
    }
}

// MARK: - Crew
struct Crew: Codable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditID: String
    let department: String
    let job: String

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case creditID = "credit_id"
        case department = "department"
        case job = "job"
    }
}
