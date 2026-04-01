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
        self.setupButtonsOfScreens()
        self.setupField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.emailTextField.widthOfTextFieldImage.constant = 0
        self.passWordTextField.widthOfTextFieldImage.constant = 0

    }
    
    //Function to Set the buttons
    func setupButtonsOfScreens(){
        self.makeUnderLineLabel(label: self.lblSignUp,text: "SIGNUP", size: 0.048, color: UIColor.white)
        self.makeUnderLineLabel(label: self.lblForgotPassword,text: "FORGOT PASSWORD ?", size: 0.048, color: UIColor.white)
        self.loginButtonView.config(text: "LOGIN",textColor: UIColor.white, size: 0.048)
        self.loginButtonView.loginButton.addTarget(self, action: #selector(self.btnLogin(_ :)), for: .touchUpInside)
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
                .font: UIFont(name: "SFAtarianSystemExtended", size: screenWidth * CGFloat(size), type: .DEFAULT) ?? UIFont.systemFont(ofSize: screenWidth * CGFloat(size))
            ]
        )
        label.attributedText = attributedString
    }
    
    //For setups the Textfields in the LoginBox
    func setupField(){
        self.emailTextField.imgForTextField.isHidden = true
        self.emailTextField.configure(labelText: "EMAIL", iconImageName: "email_icon", textFieldPlaceholder: "Enter Email", textFieldImageName: "xyz")
        self.passWordTextField.configure(labelText: "PASSWORD", iconImageName: "password_icon", textFieldPlaceholder: "Enter Password", textFieldImageName: "exya")
        self.passWordTextField.actualTextField.isSecureTextEntry = true

        // Delegate & return key types
        self.emailTextField.actualTextField.delegate = self
        self.passWordTextField.actualTextField.delegate = self
        self.emailTextField.actualTextField.returnKeyType = .next
        self.passWordTextField.actualTextField.returnKeyType = .done
    }
    
    //For Fields Validation
    func fieldsValidation () {
        let email = self.emailTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = self.passWordTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
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
        
        if let emailError = email.emailValidationError() {
            showError(emailError)
            return
        }
        
        self.loginAPI(email: email, password: password)
    }
    
    //API Call
    func loginAPI(email: String, password: String) {
        showWait()
        APIManager.sharedInstance.login(email: email, password: password) { [weak self] response, error, isSuccess in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hideWait()
                if isSuccess {
                    if let token = response?.data?.token {
                        UserDefaults.standard.set(token, forKey: "token")
                    }
                    isLoggedIn = true
                    showSuccess(response?.message ?? "Login Successfully")
                    self?.navigateToHome()
                } else {
                    showError(error ?? "Something went wrong")
                }
            }
        }
    }
    
    func navigateToHome(){
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.modalTransitionStyle = .crossDissolve
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        self.fieldsValidation()
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "OTPScreenVC") as! OTPScreenVC
        vc.screenState = .email
        vc.isForgotPassword = true
        if let emailText = emailTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !emailText.isEmpty {
            vc.enteredEmail = emailText
        }
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField.actualTextField {
            self.passWordTextField.actualTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}
