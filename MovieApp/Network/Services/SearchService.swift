//
//  SearchService.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 7.06.2022.
//

import Foundation

protocol SearchServiceProtocol {
    func searchMovie(language : String , query : String, page : Int , completion: @escaping (Result<MovieList, NetworkError>) -> Void)
}

struct SearchService: SearchServiceProtocol {
    
    //TODO: make an endpoint builder with query items
    //TODO: LOCALIZATION
    
    private let network = Network()
    
    func searchMovie(language : String = "en-US" , query : String, page : Int = 1 , completion: @escaping (Result<MovieList, NetworkError>) -> Void){
        print(AppConfig.config.baseURL + "/search/movie" + "?api_key=\(AppConfig.config.apikey)" + "&lanugage=\(language)" + "&query=\(query)" + "&page=\(page)")
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/search/movie" + "?api_key=\(AppConfig.config.apikey)" + "&lanugage=\(language)" + "&query=\(query)" + "&page=\(page)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
}
