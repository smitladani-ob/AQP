import ObjectMapper

class LoginResponse: BaseResponse {
    var data: LoginData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class LoginData: Mappable {
    var token: String?
    var user_details: UserDetails?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        token <- map["token"]
        user_details <- map["user_details"]
    }
}

class UserDetails: Mappable {
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email_id: String?
    var profile_img_original: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email_id <- map["email_id"]
        profile_img_original <- map["profile_img_original"]
    }
}
