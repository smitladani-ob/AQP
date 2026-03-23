//
//  APIManager.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import Foundation
import Alamofire
import ObjectMapper

class APIManager {
    
    static let sharedInstance = APIManager()
    
    func login(email: String,password: String,url: String,completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = url
        let device = DeviceInfo()
        let requestModel = LoginRequest(email: email, password: password, device: device)
        let params = requestModel.toJSON()
        AF.request(loginForUser, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let mapped = Mapper<LoginResponse>().map(JSON: json) {
                    completion(.success(mapped))
                } else {
                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUp(request: SignUpRequestModel,image: UIImage?,urlString: String,completion: @escaping (Result<SignUpResponseModel, Error>) -> Void) {
        let url = urlString
        
        AF.upload(multipartFormData : { multipart in
            if let requestData = request.request_data?.toJSON(),
               let jsonData = try? JSONSerialization.data(withJSONObject: requestData),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                multipart.append(Data(jsonString.utf8), withName: "request_data")
            }
            
            if let image = image,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                multipart.append(imageData,withName: "profile_img",fileName: "profile.jpg",mimeType: "image/jpeg")
            }
        },to: url)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let mapped = Mapper<SignUpResponseModel>().map(JSON: json) {
                    completion(.success(mapped))
                } else {
                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyUser(request: VerifyUserRequest,completion: @escaping (Result<VerifyUserResponse, Error>) -> Void) {
         let url = "http://192.168.0.108/ask_question_poll/api/public/api/verifyUser"
         let params = request.toJSON()
         AF.request(url,
                    method: .post,
                    parameters: params,
                    encoding: JSONEncoding.default)
         .responseJSON { response in
             switch response.result {
             case .success(let value):
                 print("VERIFY RESPONSE:", value)
                 if let json = value as? [String: Any],
                    let mapped = Mapper<VerifyUserResponse>().map(JSON: json) {
                     completion(.success(mapped))
                 } else {
                     completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                 }
             case .failure(let error):
                 completion(.failure(error))
             }
         }
     }
    
    func forgotPassword(request: ForgotPasswordRequestModel,completion: @escaping (Result<ForgotPasswordResponse, Error>) -> Void) {
        let url = "http://192.168.0.108/ask_question_poll/api/public/api/forgotPasswordForUser"
        let params = request.toJSON()
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("FORGOT PASSWORD RESPONSE:", value)
                if let json = value as? [String: Any],
                   let mapped = Mapper<ForgotPasswordResponse>().map(JSON: json) {
                    completion(.success(mapped))
                } else {
                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyForgotOTP(request: VerifyForgotOTPRequest,
                         completion: @escaping (Result<VerifyForgotOTPResponse, Error>) -> Void) {
        let url = "http://192.168.0.108/ask_question_poll/api/public/api/verifyOtpForUser"
        let params = request.toJSON()
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<500)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let mapped = Mapper<VerifyForgotOTPResponse>().map(JSON: json) {
                    completion(.success(mapped))
                } else {
                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

