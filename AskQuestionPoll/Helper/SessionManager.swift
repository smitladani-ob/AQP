//
//  SessionManager.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 25/03/26.
//

//This is for the Login Logic
import UIKit

class SessionManager {
    static let shared = SessionManager()
    private init() {}
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
        }
    }
}
