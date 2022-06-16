// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movie = try? newJSONDecoder().decode(Movie.self, from: jsonData)

import Foundation
import UIKit

// MARK: - Movie
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String?
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    var genresCSV : String{
        var genreNames : [String] = []
        for genre in genres{
            genreNames.append(genre.name)
        }
        return genreNames.joined(separator: ", ")
    }
    
    var productionCompaniesCSV : String{
        var companyNames : [String] = []
        for company in productionCompanies{
            companyNames.append(company.name)
        }
        return companyNames.joined(separator: ", ")
    }

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget = "budget"
        case genres = "genres"
        case homepage = "homepage"
        case id = "id"
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue = "revenue"
        case runtime = "runtime"
        case spokenLanguages = "spoken_languages"
        case status = "status"
        case tagline = "tagline"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    static func configureFavouriteList(with movieID: Int , imageView : UIImageView , isAlreadyFavourited : inout Bool){
        if(isAlreadyFavourited){
            isAlreadyFavourited = false
            AppConfig.config.favouriteList.removeAll(where: {$0 == movieID})
            //bookmarkImageView.image = UIImage(systemName: "bookmark")
        }
        else{
            isAlreadyFavourited = true
            AppConfig.config.favouriteList.append(movieID)
            //bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
        }
        
        let isFavourited = isAlreadyFavourited
        UIView.animate(withDuration: 0.1, animations: { 
            let newImage = isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
            imageView.transform = imageView.transform.scaledBy(x: 1.3, y: 1.3)
            imageView.image = newImage
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                imageView.transform = CGAffineTransform.identity
            })
        })
        
    }
}

// MARK: - Collection
struct Collection: Codable {
    let id: Int
    let name: String
    let posterPath: String
    let backdropPath: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}


// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case logoPath = "logo_path"
        case name = "name"
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name = "name"
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName: String
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name = "name"
    }
}



