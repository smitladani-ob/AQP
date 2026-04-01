//
//  APIManager.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import Foundation
import Alamofire
import ObjectMapper
import Network

class APIManager {
    
    static let sharedInstance = APIManager()
    let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        self.session = Session(configuration: configuration)
    }
    
    func login(email: String, password: String, completion: @escaping (_ response: LoginResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {

        let device = DeviceInfo()
        let requestModel = LoginRequest(email: email, password: password, device: device)
        let param = requestModel.toJSON()

        session.request(loginForUserUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in

            switch response.result {

            case .success(let value):

                if let json = value as? [String: Any],
                   let responseValue = Mapper<LoginResponse>().map(JSON: json) {

                    switch responseValue.code {

                    case 200:
                        completion(responseValue, nil, true)

                    case 201:
                        completion(nil, responseValue.message, false)

                    default:
                        completion(nil, responseValue.message, false)
                    }

                } else {
                    completion(nil, "Parsing Error", false)
                }

            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
//    func login(email: String,password: String,completion: @escaping (Result<LoginResponse, Error>) -> Void) {
//        let device = DeviceInfo()
//        let requestModel = LoginRequest(email: email, password: password, device: device)
//        let params = requestModel.toJSON()//for convert data to dictionary
//        session.request(loginForUserUrl, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let json = value as? [String: Any],
//                   let mapped = Mapper<LoginResponse>().map(JSON: json) { // this convert json data to Login response object
//                    if mapped.code == 200 {
//                        print(mapped.message,mapped.code)
//                        completion(.success(mapped))
//                    } else {
//                        let errorMsg = mapped.message ?? "Something went wrong"
//                        completion(.failure(NSError(domain: "AskQuestionPoll", code: mapped.code ?? 0, userInfo: [NSLocalizedDescriptionKey: errorMsg])))
//                    }
//                    
////                    switch responseValue.code {
////                    case 200:
////                        completion(responseValue.toJSON(), nil, true)
////                        break
////                    case 201:
////                        completion(nil, responseValue.message, false)
////                        break
////                    default:
////                        completion(nil, responseValue.message, false)
////                        break
////                    }
//
//                    
//                } else {
//                    completion(.failure(NSError(domain: "Parsing Error", code: 0)))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func signUp(request: SignUpRequestModel,image: UIImage?,completion: @escaping (_ response: SignUpResponseModel?, _ error: String?, _ isSuccess: Bool) -> Void) {
        session.upload(multipartFormData : { multipart in
            if let requestData = request.request_data?.toJSON(),
               let jsonData = try? JSONSerialization.data(withJSONObject: requestData),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                multipart.append(Data(jsonString.utf8), withName: "request_data")
            }
            
            if let image = image,
               let imageData = image.jpegData(compressionQuality: 0.5) {
                multipart.append(imageData,withName: "profile_img",fileName: "profile.jpg",mimeType: "image/jpeg")
            }
        },to: signupUrl)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let responseValue = Mapper<SignUpResponseModel>().map(JSON: json) {
                    switch responseValue.code {
                    case 200:
                        completion(responseValue, nil, true)
                    case 201:
                        completion(nil, responseValue.message, false)
                    default:
                        completion(nil, responseValue.message, false)
                    }
                } else {
                    completion(nil, "Parsing Error", false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
    func verifyUser(request: VerifyUserRequest,completion: @escaping (_ response: VerifyUserResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
         let params = request.toJSON()
         session.request(verifyUserUrl,method: .post,parameters: params,encoding: JSONEncoding.default).responseJSON { response in
             switch response.result {
             case .success(let value):
                 print("VERIFY RESPONSE:", value)
                 if let json = value as? [String: Any],
                    let responseValue = Mapper<VerifyUserResponse>().map(JSON: json) {
                     switch responseValue.code {
                     case 200:
                         completion(responseValue, nil, true)
                     case 201:
                         completion(nil, responseValue.message, false)
                     default:
                         completion(nil, responseValue.message, false)
                     }
                 } else {
                     completion(nil, "Parsing Error", false)
                 }
             case .failure(let error):
                 completion(nil, error.localizedDescription, false)
             }
         }
     }
    
    func forgotPassword(request: ForgotPasswordRequestModel,completion: @escaping (_ response: ForgotPasswordResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
        let params = request.toJSON()
        session.request(forgotPasswordForUserUrl,method: .post,parameters: params,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("FORGOT PASSWORD RESPONSE:", value)
                if let json = value as? [String: Any],
                   let responseValue = Mapper<ForgotPasswordResponse>().map(JSON: json) {
                    switch responseValue.code {
                    case 200:
                        completion(responseValue, nil, true)
                    case 201:
                        completion(nil, responseValue.message, false)
                    default:
                        completion(nil, responseValue.message, false)
                    }
                } else {
                    completion(nil, "Parsing Error", false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
    func verifyForgotOTP(request: VerifyForgotOTPRequest,completion: @escaping (_ response: VerifyForgotOTPResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
        let params = request.toJSON()
        session.request(verifyOtpForUserUrl,method: .post,parameters: params,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                if let json = value as? [String: Any],
                   let responseValue = Mapper<VerifyForgotOTPResponse>().map(JSON: json) {
                    switch responseValue.code {
                    case 200:
                        completion(responseValue, nil, true)
                    case 201:
                        completion(nil, responseValue.message, false)
                    default:
                        completion(nil, responseValue.message, false)
                    }
                } else {
                    completion(nil, "Parsing Error", false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
    func setNewPassword(request: GenerateNewPasswordRequest,completion: @escaping (_ response: GenerateNewPasswordResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
        let params = request.toJSON()
        session.request(generateNewPasswordForUser,method: .post,parameters: params,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let responseValue = Mapper<GenerateNewPasswordResponse>().map(JSON: json) {
                    switch responseValue.code {
                    case 200:
                        completion(responseValue, nil, true)
                    case 201:
                        completion(nil, responseValue.message, false)
                    default:
                        completion(nil, responseValue.message, false)
                    }
                } else {
                    completion(nil, "Parsing Error", false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
    func addQuestion(requestModel: AddQuestionRequest, images: AddQuestionImages?, completion: @escaping (_ response: AddQuestionResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"]
        session.upload(multipartFormData: { multipart in
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
        }, to: addQuestionUrl, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                     if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let responseValue = Mapper<AddQuestionResponse>().map(JSON: json) {
                         switch responseValue.code {
                         case 200:
                             completion(responseValue, nil, true)
                         case 201:
                             completion(nil, responseValue.message, false)
                         default:
                             completion(nil, responseValue.message, false)
                         }
                     } else {
                         completion(nil, "Mapping failed", false)
                     }
                } catch {
                    completion(nil, error.localizedDescription, false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
    func getQuestions(completion: @escaping (_ response: QuestionResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token missing")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)","Content-Type": "application/json"
        ]
        session.request(getAllQuestionByUserUrl,method: .post,parameters: [:],encoding: JSONEncoding.default,headers: headers).responseDecodable(of: QuestionResponse.self) { response in
            switch response.result {
            case .success(let data):
                switch data.code {
                case 200:
                    completion(data, nil, true)
                case 201:
                    completion(nil, data.message, false)
                default:
                    completion(nil, data.message, false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
    
    func viewQuestions(completion: @escaping (_ response: ViewQuestionResponse?, _ error: String?, _ isSuccess: Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token"), !token.isEmpty else {
            completion(nil, "Token Missing", false)
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)","Accept": "application/json"]
        session.request(viewQuestionsUrl, method: .post, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                guard !data.isEmpty else {
                    completion(nil, "Empty Response", false)
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let responseValue = Mapper<ViewQuestionResponse>().map(JSON: json) {
                        switch responseValue.code {
                        case 200:
                            completion(responseValue, nil, true)
                        case 201:
                            completion(nil, responseValue.message, false)
                        default:
                            completion(nil, responseValue.message, false)
                        }
                    } else {
                        completion(nil, "Mapping failed", false)
                    }
                } catch {
                    print("JSON parsing failed:", error)
                    completion(nil, error.localizedDescription, false)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription, false)
            }
        }
    }
}

