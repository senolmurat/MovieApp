//
//  Company.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import Foundation

import Foundation

// MARK: - Company
struct Company: Codable {
    let companyDescription: String
    let headquarters: String
    let homepage: String
    let id: Int
    let logoPath: String
    let name: String
    let originCountry: String
    let parentCompany: ParentCompany

    enum CodingKeys: String, CodingKey {
        case companyDescription = "description"
        case headquarters = "headquarters"
        case homepage = "homepage"
        case id = "id"
        case logoPath = "logo_path"
        case name = "name"
        case originCountry = "origin_country"
        case parentCompany = "parent_company"
    }
}

// MARK: - ParentCompany
struct ParentCompany: Codable {
    let name: String
    let id: Int
    let logoPath: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case logoPath = "logo_path"
    }
}
