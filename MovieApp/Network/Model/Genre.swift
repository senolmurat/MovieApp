//
//  Genre.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import Foundation


struct Genres: Codable{
    let genres : [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
