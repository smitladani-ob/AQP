//
//  CountryModel.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//
import Foundation

struct Country: Codable {
    let name: String
    let dialCode: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
}

struct CountryResponse: Codable {
    let countryJSON: [Country]
    
    enum CodingKeys: String, CodingKey {
        case countryJSON = "country_JSON"
    }
}
