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

var isLoggedIn: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
    }
}

// Flags to track when to refresh data
var firstTabNeedsRefresh: Bool = true
var fourthTabNeedsRefresh: Bool = true


