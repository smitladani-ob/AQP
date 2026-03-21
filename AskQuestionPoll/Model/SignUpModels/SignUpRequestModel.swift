//
//  SignUpRequestModel.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import Foundation
import ObjectMapper

class SignUpRequestModel: Mappable {
    var request_data: UserData?
    var profile_img: String?
    
    init(request_data: UserData, profile_img: String? = nil) {
        self.request_data = request_data
        self.profile_img = profile_img
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        request_data <- map["request_data"]
        profile_img <- map["profile_img"]
    }
}

class UserData: Mappable {
    var first_name: String?
    var last_name: String?
    var email_id: String?
    var password: String?
    var gender: Gender?
    var country: String?
    
    init(first_name: String? = nil, last_name: String? = nil, email_id: String? = nil, password: String? = nil, gender: Gender? = nil, country: String? = nil) {
        self.first_name = first_name
        self.last_name = last_name
        self.email_id = email_id
        self.password = password
        self.gender = gender
        self.country = country
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email_id <- map["email_id"]
        password <- map["password"]
        gender <- (map["gender"], EnumTransform<Gender>())      
        country <- map["country"]
    }
}

enum Gender: Int {
    case male = 1
    case female = 2
}
