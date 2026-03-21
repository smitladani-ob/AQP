//
//  OTPResponseModel.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import Foundation
import ObjectMapper

class VerifyUserResponse: Mappable {
    
    var code: Int?
    var message: String?
    var cause: String?
    var data: VerifyUserData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        cause <- map["cause"]
        data <- map["data"]
    }
}

class VerifyUserData: Mappable {
    var token: String?
    var user: User?
    required init?(map: Map) {}
    func mapping(map: Map) {
        token <- map["token"]
        user <- map["user"]
    }
}

class User: Mappable {
    var first_name: String?
    var last_name: String?
    var email_id: String?
    var gender: String?
    var country: String?
    var profile_img: String?
    var compress_img: String?
    var original_img: String?
    var thumbnail_img: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email_id <- map["email_id"]
        gender <- map["gender"]
        country <- map["country"]
        profile_img <- map["profile_img"]
        compress_img <- map["compress_img"]
        original_img <- map["original_img"]
        thumbnail_img <- map["thumbnail_img"]
    }
}
