//
//  MovieImage.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import Foundation

// MARK: - MovieImageList
struct MovieImageList: Codable {
    let id: Int //MovieId
    let backdrops: [MovieImage]
    let posters: [MovieImage]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case backdrops = "backdrops"
        case posters = "posters"
    }
}

// MARK: - Backdrop
struct MovieImage: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let iso639_1: String?
    let voteAverage: Double
    let voteCount: Int
    let width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height = "height"
        case iso639_1 = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width = "width"
    }
}
