//
//  SignUpResponseModel.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import Foundation
import ObjectMapper


class SignUpResponseModel: Mappable {
    
    var code: Int?
    var message: String?
    var cause: String?
    var data: DataOne?
    
    init(code: Int? = nil, message: String? = nil, cause: String? = nil, data: DataOne? = nil) {
        self.code = code
        self.message = message
        self.cause = cause
        self.data = data
    }
    
    required init?(map: ObjectMapper.Map) { }
    
    func mapping(map: ObjectMapper.Map) {
        code <- map["code"]
        message <- map["message"]
        cause <- map["cause"]
        data <- map["data"]
    }
}

class DataOne: Mappable {
    
    var user_reg_temp_id: Int?
    
    init(user_reg_temp_id: Int? = nil) {
        self.user_reg_temp_id = user_reg_temp_id
    }
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        user_reg_temp_id <- map["user_reg_temp_id"]
    }
}
