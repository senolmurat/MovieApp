//
//  PersonService.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 3.06.2022.
//

import Foundation

protocol PersonServiceProtocol {
    func getDetails(personID : Int , language : String ,completion: @escaping (Result<People, NetworkError>) -> Void)
    func getPopular(page : Int ,language : String , completion: @escaping (Result<PeopleList, NetworkError>) -> Void)
}

struct PersonService: PersonServiceProtocol {
    
    //TODO: make an endpoint builder with query items
    
    private let network = Network()
    
    func getDetails(personID : Int , language : String = "en-US" ,completion: @escaping (Result<People, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/person/\(personID)" + "?api_key=\(AppConfig.config.apikey)" + "&language=\(language)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    func getPopular(page : Int ,language : String = "en-US" , completion: @escaping (Result<PeopleList, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/person/popular" + "?api_key=\(AppConfig.config.apikey)" + "&language=\(language)" + "&page=\(page)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
}
