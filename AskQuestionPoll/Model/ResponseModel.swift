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

//MARK: get all Question

struct QuestionResponse: Codable {
    let code: Int?
    let message: String?
    let data: QuestionData?
}

struct QuestionData: Codable {
    let result: [[Question]]?
    enum CodingKeys: String, CodingKey {
        case result
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Try array of array
        if let array = try? container.decode([[Question]].self, forKey: .result) {
            result = array
        }
        // Try single array
        else if let single = try? container.decode([Question].self, forKey: .result) {
            result = [single]
        }
        // Try dictionary (rare bad API case)
        else if let dict = try? container.decode([String: [Question]].self, forKey: .result) {
            result = Array(dict.values)
        }
        else {
            result = []
        }
    }
}

struct Question: Codable {
    let userId: Int?
    let questionId: Int?
    let description: String?
    let option1: String?
    let option2: String?
    let optionType: Int?

    // ADD OPTIONAL SAFE FIELDS
    let questionCompress: String?
    let questionOriginal: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case questionId = "question_id"
        case description
        case option1
        case option2
        case optionType = "option_type"
        case questionCompress = "question_compress"
        case questionOriginal = "question_original"
    }
}

//MARK: View Question Response

class ViewQuestionResponse: BaseResponse {
    var data: ViewQuestionData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class ViewQuestionData: Mappable {
    var result: [ViewQuestion]?
    required init?(map: Map) {}
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class ViewQuestion: Mappable {
    var user_id: Int?
    var description: String?
    var option1: String?
    var option2: String?
    var option_type: Int?
    var question_compress: String?
    var option1_compress_image: String?
    var option2_compress_image: String?
    required init?(map: Map) {}
    func mapping(map: Map) {
        user_id <- map["user_id"]
        description <- map["description"]
        option1 <- map["option1"]
        option2 <- map["option2"]
        option_type <- map["option_type"]
        question_compress <- map["question_compress"]
        option1_compress_image <- map["option1_compress_image"]
        option2_compress_image <- map["option2_compress_image"]
    }
}

