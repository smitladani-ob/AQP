//
//  LogOutVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 25/03/26.
//

import UIKit

class LogOutVC: UIViewController {
    
    @IBOutlet weak var logOutButton: yellowButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        logOutButton.config(text: "LOGOUT", textColor: UIColor.black)
        logOutButton.loginButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logOutButtonTapped() {
        SessionManager.shared.isLoggedIn = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
