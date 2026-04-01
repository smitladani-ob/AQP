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
        logOutButton.config(text: "LOGOUT", textColor: UIColor.black, size: 0.048)
        logOutButton.loginButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logOutButtonTapped() {
        isLoggedIn = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let loginVC = storyboardOfMain.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav = UINavigationController(rootViewController: loginVC)
        nav.navigationBar.isHidden = false
        appDelegate.window?.rootViewController = nav
        appDelegate.window?.makeKeyAndVisible()
    }
}
