import ObjectMapper

class BaseResponse: Mappable {
    var code: Int?
    var message: String?
    var cause: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
    }
}

//MARK: LOGIN
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

//MARK: SIGNUP

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

//MARK: ForgotPasswordResponse
class ForgotPasswordResponse: BaseResponse { //BaseResponse is in the LoginResponse
    
}


//MARK: VERIFY USER

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


//MARK: VerifyForgotOTPResponse
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
    var token: String?
    required init?(map: Map) {}
    func mapping(map: Map) {
        token <- map["token"]
    }
}


//MARK: setpassword APi
class GenerateNewPasswordResponse: BaseResponse { //BaseResponse is in the LoginResponse
    
}


//MARK: ADD Question

class AddQuestionResponse: BaseResponse {
    var data: [String: Any]?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
