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
    
    func login(email: String,password: String,completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let device = DeviceInfo()
        let requestModel = LoginRequest(email: email, password: password, device: device)
        let params = requestModel.toJSON()//for convert data to dictionary
        AF.request(loginForUserUrl, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let mapped = Mapper<LoginResponse>().map(JSON: json) { // this convert json data to Login response object
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
         let params = request.toJSON()
         AF.request(verifyUserUrl,
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
        let params = request.toJSON()
        AF.request(forgotPasswordForUserUrl,
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
        let params = request.toJSON()
        AF.request(verifyOtpForUserUrl,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<500)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
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
    
    func setNewPassword(request: GenerateNewPasswordRequest,
                        completion: @escaping (Result<GenerateNewPasswordResponse, Error>) -> Void) {
        let params = request.toJSON()
        AF.request(generateNewPasswordForUser,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<500)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let mapped = Mapper<GenerateNewPasswordResponse>().map(JSON: json) {
                    completion(.success(mapped))
                } else {
                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addQuestion(requestModel: AddQuestionRequest, images: AddQuestionImages?, completion: @escaping (Result<AddQuestionResponse, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
        ]
        AF.upload(multipartFormData: { multipart in
            // Request data JSON
            let requestData = requestModel.toJSON()
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData),
                  let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            multipart.append(Data(jsonString.utf8), withName: "request_data")
            // Question image
            if let questionImg = images?.questionImage,
               let imgData = questionImg.jpegData(compressionQuality: 0.8) {
                multipart.append(imgData, withName: "question_image", fileName: "question_image.jpg", mimeType: "image/jpeg")
            }
            // Option images
            if let option1Img = images?.option1Image,
               let imgData = option1Img.jpegData(compressionQuality: 0.8) {
                multipart.append(imgData, withName: "option1", fileName: "option_1.jpg", mimeType: "image/jpeg")
            }
            if let option2Img = images?.option2Image,
               let imgData = option2Img.jpegData(compressionQuality: 0.8) {
                multipart.append(imgData, withName: "option2", fileName: "option_2.jpg", mimeType: "image/jpeg")
            }
        }, to: addQuestionUrl, headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let mapped = Mapper<AddQuestionResponse>().map(JSON: json) {
                    completion(.success(mapped))
                } else {
                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getQuestions(completion: @escaping (Result<QuestionResponse, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token missing")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)","Content-Type": "application/json"
        ]
        AF.request(getAllQuestionByUserUrl,
                   method: .post,
                   parameters: [:],
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: QuestionResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func viewQuestions(completion: @escaping (Result<ViewQuestionResponse, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token"), !token.isEmpty else {
            completion(.failure(NSError(domain: "Token Missing", code: 401)))
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        AF.request(viewQuestionsUrl, method: .post, headers: headers)
        .validate(statusCode: 200..<500)
        .responseData { response in
            switch response.result {
            case .success(let data):
                let rawString = String(data: data, encoding: .utf8) ?? "nil"
                print("🚨 Raw response string: \(rawString)")
                guard !data.isEmpty else {
                    completion(.failure(NSError(domain: "Empty Response", code: 0)))
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let mapped = Mapper<ViewQuestionResponse>().map(JSON: json) {
                        completion(.success(mapped))
                    } else {
                        completion(.failure(NSError(domain: "Mapping failed", code: 0)))
                    }
                } catch {
                    print("JSON parsing failed:", error)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

