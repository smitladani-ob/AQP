import ObjectMapper

//MARK: LOGIN
class LoginRequest: Mappable {
    var email_id: String?
    var password: String?
    var device_info: DeviceInfo?
    
    init(email: String, password: String, device: DeviceInfo) {
        self.email_id = email
        self.password = password
        self.device_info = device
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        password <- map["password"]
        device_info <- map["device_info"]
    }
}

class DeviceInfo: Mappable {
    var device_reg_id: String?
    var device_platform: String?
    var device_model_name: String?
    var device_vendor_name: String?
    var device_os_version: String?
    var device_udid: String?
    var device_resolution: String?
    var device_carrier: String?
    var device_country_code: String?
    var device_language: String?
    var device_local_code: String?
    var device_default_time_zone: String?
    var device_library_version: String?
    var device_application_version: String?
    var device_type: String?
    var device_registration_date: String?
    var is_active: String?
    
    init(){
        self.device_reg_id = "TEST_REG_ID"
        self.device_platform = "ios"
        self.device_model_name = UIDevice.current.model
        self.device_vendor_name = "Apple"
        self.device_os_version = UIDevice.current.systemVersion
        self.device_udid = UIDevice.current.identifierForVendor?.uuidString
        self.device_resolution = "\(UIScreen.main.bounds.width)*\(UIScreen.main.bounds.height)"
        self.device_carrier = ""
        self.device_country_code = "IN"
        self.device_language = Locale.current.identifier
        self.device_local_code = Locale.current.identifier
        self.device_default_time_zone = TimeZone.current.identifier
        self.device_library_version = ""
        self.device_application_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.device_type = "phone"
        self.device_registration_date = "\(Date())"
        self.is_active = "0"
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        device_reg_id <- map["device_reg_id"]
        device_platform <- map["device_platform"]
        device_model_name <- map["device_model_name"]
        device_vendor_name <- map["device_vendor_name"]
        device_os_version <- map["device_os_version"]
        device_udid <- map["device_udid"]
        device_resolution <- map["device_resolution"]
        device_carrier <- map["device_carrier"]
        device_country_code <- map["device_country_code"]
        device_language <- map["device_language"]
        device_local_code <- map["$device_local_code"]
        device_default_time_zone <- map["device_default_time_zone"]
        device_library_version <- map["device_library_version"]
        device_application_version <- map["device_application_version"]
        device_type <- map["device_type"]
        device_registration_date <- map["device_registration_date"]
        is_active <- map["is_active"]
    }
}

//MARK: SIGNUP
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

//MARK: ForgotPasswordRequestModel
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

//MARK: VERIFY USER
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

//MARK: VERIFY FORGOT PASSWORD
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

//MARK: GENERATE NEW PASSWORD

class GenerateNewPasswordRequest: Mappable {
    var email_id: String?
    var password: String?
    var token: String?
    
    init(email: String, password: String, token: String) {
        self.email_id = email
        self.password = password
        self.token = token
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        password <- map["password"]
        token     <- map["token"]
    }
}

// For Add Question it is in the HomeScreen
class AddQuestionRequest: Mappable {
    var category_id: Int?
    var country: String?
    var gender: Int?
    var description: String?
    var option_type: Int? // 1=text, 2=image
    var option1: String?
    var option2: String?

    init(category_id: Int?, country: String?, gender: Int?, description: String?, option_type: Int?, option1: String?, option2: String?) {
        self.category_id = category_id
        self.country = country
        self.gender = gender
        self.description = description
        self.option_type = option_type
        self.option1 = option1
        self.option2 = option2
    }

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        category_id <- map["category_id"]
        country     <- map["country"]
        gender      <- map["gender"]
        description <- map["description"]
        option_type <- map["option_type"]
        option1     <- map["option1"]
        option2     <- map["option2"]
    }
}

struct AddQuestionImages {
    var questionImage: UIImage?
    var option1Image: UIImage?
    var option2Image: UIImage?
}
