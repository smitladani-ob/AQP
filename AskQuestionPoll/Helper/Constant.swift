//
//  Constant.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

let storyboardOfMain = UIStoryboard(name: "Main", bundle: nil)

var screenWidth: CGFloat {
    return isiPadDevice ? 475 : UIScreen.main.bounds.size.width
}

var isiPadDevice: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

let isSmallScreen = UIScreen.main.bounds.height <= 667

//MARK: APIs
let serverUrl = "http://192.168.0.108/ask_question_poll/api/public/api/"
let loginForUserUrl = serverUrl + "loginForUser"
let signupUrl = serverUrl + "signup"
let verifyUserUrl = serverUrl + "verifyUser"
let forgotPasswordForUserUrl = serverUrl + "forgotPasswordForUser"
let verifyOtpForUserUrl = serverUrl + "verifyOtpForUser"
let generateNewPasswordForUser = serverUrl + "generateNewPasswordForUser"
let addQuestionUrl = serverUrl + "addQuestion"
let getAllQuestionByUserUrl = serverUrl + "getAllQuestionByUser"
let viewQuestionsUrl = serverUrl + "viewQuestions"
//let signup = serverUrl + "signup"

//JSON Parser
class JSONLoader {
    static func load<T: Decodable>(_ fileName: String) -> T? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File not found: \(fileName)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding \(fileName):", error)
            return nil
        }
    }
}



//For left nav bar button

