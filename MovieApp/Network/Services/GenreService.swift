//
//  GenreService.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import Foundation

protocol GenreServiceProtocol {
    func getMovieGenreList(language : String , completion: @escaping (Result<Genres, NetworkError>) -> Void)
    func getTVGenreList(language : String , completion: @escaping (Result<Genres, NetworkError>) -> Void)
}

struct GenreService: GenreServiceProtocol {
    //TODO: make an endpoint builder with query items
    //TODO: LOCALIZATION
    
    private let network = Network()
    
    func getMovieGenreList(language : String = "en-US" , completion: @escaping (Result<Genres, NetworkError>) -> Void){
        print(AppConfig.config.baseURL + "/genre/movie/list" + "?api_key=\(AppConfig.config.apikey)" + "&language=\(language)")
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/genre/movie/list" + "?api_key=\(AppConfig.config.apikey)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getTVGenreList(language : String , completion: @escaping (Result<Genres, NetworkError>) -> Void){
        
    }
    
    
}
