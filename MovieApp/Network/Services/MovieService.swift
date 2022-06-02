//
//  MovieService.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import Foundation

protocol MovieServiceProtocol {
    func getMovieDetail(id: Int, completion: @escaping (Result<Movie, NetworkError>) -> Void)
    func getRecommendations(id: Int, completion: @escaping (Result<MovieList, NetworkError>) -> Void)
    func getPopular(page : Int,completion: @escaping (Result<MovieList, NetworkError>) -> Void)
    func getCredits(movieID : Int ,completion: @escaping (Result<Credits, NetworkError>) -> Void)
    func getImages(movieID : Int ,completion: @escaping (Result<MovieImageList, NetworkError>) -> Void)
}

struct MovieService: MovieServiceProtocol {
    //TODO: make an endpoint builder with query items
    //TODO: LOCALIZATION
    
    private let network = Network()
    
    func getMovieDetail(id: Int, completion: @escaping (Result<Movie, NetworkError>) -> Void) {
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(id)" + "?api_key=\(AppConfig.config.apikey)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getRecommendations(id: Int, completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        
    }
    
    func getPopular(page : Int,completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        print(AppConfig.config.baseURL + "/movie/popular" + "?api_key=\(AppConfig.config.apikey)" + "&page=\(page)")
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/popular" + "?api_key=\(AppConfig.config.apikey)" + "&page=\(page)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getCredits(movieID : Int ,completion: @escaping (Result<Credits, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(movieID)/credits" + "?api_key=\(AppConfig.config.apikey)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getImages(movieID : Int ,completion: @escaping (Result<MovieImageList, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/movie/\(movieID)/images" + "?api_key=\(AppConfig.config.apikey)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
}

