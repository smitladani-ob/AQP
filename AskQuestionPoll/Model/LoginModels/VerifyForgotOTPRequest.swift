import ObjectMapper

class VerifyForgotOTPRequest: Mappable {
    
    var email_id: String?
    var token: Int?
    
    init(email: String, token: Int) {
        self.email_id = email
        self.token = token
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        token    <- map["token"]
    }
}
