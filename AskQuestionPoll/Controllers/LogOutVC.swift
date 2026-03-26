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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI() {
        logOutButton.config(text: "LOGOUT", textColor: UIColor.black)
        logOutButton.loginButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logOutButtonTapped() {
        SessionManager.shared.isLoggedIn = false
        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            // If we have a navigation stack, just pop to root
            nav.popToRootViewController(animated: true)
        } else {
            // No navigation stack → replace root VC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController(rootViewController: loginVC)
            UIApplication.shared.keyWindow?.rootViewController = nav
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
}
