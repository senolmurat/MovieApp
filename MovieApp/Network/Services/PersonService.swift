//
//  PersonService.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 3.06.2022.
//

import Foundation

protocol PersonServiceProtocol {
    func getDetails(personID : Int , completion: @escaping (Result<People, NetworkError>) -> Void)
}

struct PersonService: PersonServiceProtocol {
    
    //TODO: make an endpoint builder with query items
    //TODO: LOCALIZATION
    
    private let network = Network()
    
    func getDetails(personID : Int , completion: @escaping (Result<People, NetworkError>) -> Void){
        let urlRequest = URLRequest(url: URL(string: AppConfig.config.baseURL + "/person/\(personID)" + "?api_key=\(AppConfig.config.apikey)")!)
        network.performRequest(request: urlRequest, completion: completion)
    }
    
    
}
