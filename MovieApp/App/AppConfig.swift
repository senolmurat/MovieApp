//
//  AppConfig.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import Foundation

class AppConfig{
    
    static let config = AppConfig()
    
    let appName = "MovieApp"
    let apikey : String = Bundle.main.infoDictionary?["API_KEY"] as! String
    let baseURL : String = Bundle.main.infoDictionary?["BASE_API_URL"] as! String
    let originalImageURL : String = Bundle.main.infoDictionary?["ORIGINAL_IMAGE_URL"] as! String
    //TODO Give errors if key not found in infoDictionary
    //TODO get selected Language from a stored plist
    
    let defaultBackdropImage : String = "defaultBackdropImage"
    let defaultPosterImage : String = "defaultPosterImage"
    let defaultActorImage : String = "defaultActorImage"
    
}
