//
//  MovieService.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import Foundation

protocol MovieServiceProtocol {
    func getMovieDetail(id: Int, language : String ,completion: @escaping (Result<Movie, NetworkError>) -> Void)
    func getRecommendations(id: Int, language : String ,completion: @escaping (Result<MovieList, NetworkError>) -> Void)
    func getPopular(page : Int, language : String ,completion: @escaping (Result<MovieList, NetworkError>) -> Void)
    func getUpcoming(page : Int, language : String ,completion: @escaping (Result<MovieList, NetworkError>) -> Void)
    func getNowPlaying(page : Int, language : String ,completion: @escaping (Result<MovieList, NetworkError>) -> Void)
    func getCredits(movieID : Int , language : String ,completion: @escaping (Result<Credits, NetworkError>) -> Void)
    func getImages(movieID : Int ,completion: @escaping (Result<MovieImageList, NetworkError>) -> Void)
    func getDiscover(page : Int, language : String, sortBy : String, minVoteCount : Int ,completion: @escaping (Result<MovieList, NetworkError>) -> Void)
}

struct MovieService: MovieServiceProtocol {
    //TODO: make an endpoint builder with query items
    
    private let network = Network()
    
    func getMovieDetail(id: Int, language : String = "en-US" ,completion: @escaping (Result<Movie, NetworkError>) -> Void) {
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(id)" + "?api_key=\(AppConfig.config.apikey)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getRecommendations(id: Int, language : String = "en-US" ,completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(id)/recommendations" + "?api_key=\(AppConfig.config.apikey)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getPopular(page : Int, language : String = "en-US" ,completion: @escaping (Result<MovieList, NetworkError>) -> Void){
        print(AppConfig.config.baseURL + "/movie/popular" + "?api_key=\(AppConfig.config.apikey)" + "&page=\(page)")
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/popular" + "?api_key=\(AppConfig.config.apikey)" + "&page=\(page)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getUpcoming(page : Int, language : String = "en-US" ,completion: @escaping (Result<MovieList, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/upcoming" + "?api_key=\(AppConfig.config.apikey)" + "&page=\(page)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getNowPlaying(page : Int, language : String = "en-US" ,completion: @escaping (Result<MovieList, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/now_playing" + "?api_key=\(AppConfig.config.apikey)" + "&page=\(page)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getCredits(movieID : Int , language : String = "en-US" ,completion: @escaping (Result<Credits, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(movieID)/credits" + "?api_key=\(AppConfig.config.apikey)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getImages(movieID : Int ,completion: @escaping (Result<MovieImageList, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(movieID)/images" + "?api_key=\(AppConfig.config.apikey)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getDiscover(page : Int, language : String, sortBy : String = sortBy.popularity_desc.rawValue, minVoteCount : Int = 1000 ,completion: @escaping (Result<MovieList, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/discover/movie" + "?api_key=\(AppConfig.config.apikey)"  + "&page=\(page)" + "&language=\(language)"  + "&sort_by=\(sortBy)" + "&vote_count.gte=\(minVoteCount)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
}

enum sortBy : String {
    case popularity_asc = "popularity.asc"
    case popularity_desc = "popularity.desc"
    case release_date_asc = "release_date.asc"
    case release_date_desc = "release_date.desc"
    case revenue_asc = "revenue.asc"
    case revenue_desc = "revenue.desc"
    case primary_release_date_asc = "primary_release_date.asc"
    case primary_release_date_desc = "primary_release_date.desc"
    case original_title_asc = "original_title.asc"
    case original_title_desc = "original_title.desc"
    case vote_avarage_asc = "vote_avarage.asc"
    case vote_avarage_desc = "vote_avarage.desc"
    case vote_count_asc = "vote_count.asc"
    case vote_count_desc = "vote_count.desc"
}

enum monetizationType : String {
    case flatrate = "flatrate"
    case free = "free"
    case ads = "ads"
    case rent = "rent"
    case buy = "buy"
}

