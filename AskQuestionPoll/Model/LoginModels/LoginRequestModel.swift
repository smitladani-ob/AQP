import ObjectMapper

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
