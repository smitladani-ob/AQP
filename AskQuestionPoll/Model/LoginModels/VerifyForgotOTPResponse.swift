import ObjectMapper

class VerifyForgotOTPResponse: Mappable {
    
    var code: Int?
    var message: String?
    var cause: String?
    var data: VerifyForgotOTPData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}

class VerifyForgotOTPData: Mappable {
    
    var token: String?   // 🔥 important (used for reset password)
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        token <- map["token"]
    }
}
