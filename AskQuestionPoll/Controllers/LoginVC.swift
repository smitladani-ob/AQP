//
//  ViewController.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit
import SCLAlertView

class LoginVC: UIViewController {
    
    @IBOutlet weak var lblSignUp: UILabel!
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var passWordTextField: AuthTextFieldView!
    @IBOutlet weak var emailTextField: AuthTextFieldView!
    @IBOutlet weak var loginButtonView: yellowButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        btnSignUp.titleLabel?.text = "Signup"
        setupButtonsOfScreens()
        setupField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        emailTextField.widthOfTextFieldImage.constant = 0
        passWordTextField.widthOfTextFieldImage.constant = 0

    }
    
    //Function to Set the buttons
    func setupButtonsOfScreens(){
        makeUnderLineLabel(label: lblSignUp,text: "SIGNUP", size: 0.048, color: UIColor.white)
        makeUnderLineLabel(label: lblForgotPassword,text: "FORGOT PASSWORD ?", size: 0.048, color: UIColor.white)
        loginButtonView.config(text: "LOGIN",textColor: UIColor.white)
        loginButtonView.loginButton.addTarget(self, action: #selector(btnLogin(_ :)), for: .touchUpInside)
    }
    
    //Fucntion to give attributed text which give underline to label's text
    func makeUnderLineLabel(label: UILabel,text: String, size: CFloat, color: UIColor) {
        let text = text
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .underlineStyle: NSUnderlineStyle.thick.rawValue,
                .foregroundColor: color,
                //                .font: UIFont.systemFont(ofSize: screenWidth * CGFloat(size), weight: .bold)
                .font: UIFont(name: "SFAtarianSystemExtended",size: screenWidth * CGFloat(size))!
            ]
        )
        label.attributedText = attributedString
    }
    
    //For setups the Textfields in the LoginBox
    func setupField(){
        emailTextField.imgForTextField.isHidden = true
        emailTextField.configure(labelText: "EMAIL", iconImageName: "email_icon", textFieldPlaceholder: "Enter Email", textFieldImageName: "xyz")
        passWordTextField.configure(labelText: "PASSWORD", iconImageName: "password_icon", textFieldPlaceholder: "Enter Password", textFieldImageName: "exya")
        passWordTextField.actualTextField.isSecureTextEntry = true

        // Delegate & return key types
        emailTextField.actualTextField.delegate = self
        passWordTextField.actualTextField.delegate = self
        emailTextField.actualTextField.returnKeyType = .next
        passWordTextField.actualTextField.returnKeyType = .done
    }
    
    //For Fields Validation
    func fieldsValidation () {
        let email = emailTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passWordTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        //Incase Both Field Empty
        if email.isEmpty && password.isEmpty {
            showError("Please Enter Information")
            return
        }
        
        //Incase Email Field Empty
        if email.isEmpty {
            showError("Please Enter Email")
            return
        }
        
        //Incase Password Field Empty
        if password.isEmpty {
            showError("Please Enter Password")
            return
        }
        
        loginAPI(email: email, password: password)
    }
    
    //API Call
    func loginAPI(email: String, password: String) {
        let waitAlert = alert.showWait("Please Wait", subTitle: "",colorStyle: 0xFFEB3B)
        APIManager.sharedInstance.login(email: email, password: password) { response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                waitAlert.close()
                switch response {
                case .success(let response):
                    if response.code == 200 {
                        if let token = response.data?.token {
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.synchronize()
                            print(token)
                        }
                        SessionManager.shared.isLoggedIn = true
                        showSuccess(response.message ?? "Login Successfully")
                        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        showError(response.message ?? "Something went wrong")
                    }
                case .failure(let error):
                    showError("Something went wrong")
                }
            }
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.navigationController?.setupGlobalBackButton()
        vc.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        fieldsValidation()
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "OTPScreenVC") as! OTPScreenVC
        vc.screenState = .email
        vc.isForgotPassword = true
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField.actualTextField {
            passWordTextField.actualTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}
