//
//  OTPRequestModel.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import Foundation
import ObjectMapper

class VerifyUserRequest: Mappable {
    
    var user_reg_temp_id: Int?
    var token: Int?
    var device_info: DeviceInfo?
    
    init(userId: Int, token: Int, device: DeviceInfo) {
        self.user_reg_temp_id = userId
        self.token = token
        self.device_info = device
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        user_reg_temp_id <- map["user_reg_temp_id"]
        token            <- map["token"]
        device_info      <- map["device_info"]
    }
}
