//
//  MovieListResult.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import Foundation

// MARK: - MovieList
struct MovieList: Codable {
    let page: Int
    let results: [MovieListResult]
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
struct MovieListResult: Codable {
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String?
    let genreIDS: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    var genresCSV : String{
        var genreNames : [String] = []
        for genreID in genreIDS{
            if let genreName = AppConfig.config.genres[genreID]{
                genreNames.append(genreName)
            }
        }
        return genreNames.joined(separator: ", ")
    }


    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id = "id"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title = "title"
        case backdropPath = "backdrop_path"
        case popularity = "popularity"
        case voteCount = "vote_count"
        case video = "video"
        case voteAverage = "vote_average"
    }
}
