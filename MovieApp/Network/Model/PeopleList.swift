//
//  PeopleList.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 6.06.2022.
//

import Foundation

// MARK: - PeopleList
struct PeopleList: Codable {
    let page: Int
    let results: [PeopleListResult]
    let totalResults: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// MARK: - Result
struct PeopleListResult: Codable {
    let profilePath: String?
    let adult: Bool
    let id: Int
    var known_for: NSNull{
        return NSNull()
    }
    let name: String
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case adult = "adult"
        case id = "id"
        //case knownFor = "known_for"
        case name = "name"
        case popularity = "popularity"
    }
}
