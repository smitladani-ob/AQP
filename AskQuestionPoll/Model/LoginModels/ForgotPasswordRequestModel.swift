//
//  ForgotPasswordRequestModel.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import Foundation
import ObjectMapper

class ForgotPasswordRequestModel: Mappable {
    var email_id: String?
    
    init(email_id: String?){
        self.email_id = email_id
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
    }
}
