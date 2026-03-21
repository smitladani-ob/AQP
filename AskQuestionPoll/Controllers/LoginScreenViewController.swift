//
//  ViewController.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit
import SCLAlertView

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFaceBook: UIButton!
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
    
    //Function to Set the buttons
    func setupButtonsOfScreens(){
        makeUnderLineLabel(label: lblSignUp,text: "SIGNUP", size: 0.048, color: UIColor.white)
        makeUnderLineLabel(label: lblForgotPassword,text: "FORGOT PASSWORD ?", size: 0.048, color: UIColor.white)
        loginButtonView.config(text: "LOGIN")
        loginButtonView.loginButton.addTarget(self, action: #selector(btnLogin(_ :)), for: .touchUpInside)
        let tappedForgot = UITapGestureRecognizer(target: self, action: #selector(btnForgotPassword(_ :)))
        lblForgotPassword.isUserInteractionEnabled = true
        lblForgotPassword.addGestureRecognizer(tappedForgot)
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
        passWordTextField.imgForTextField.isHidden = true
        passWordTextField.configure(labelText: "PASSWORD", iconImageName: "password_icon", textFieldPlaceholder: "Enter Password", textFieldImageName: "exya")
        passWordTextField.actualTextField.isSecureTextEntry = true
    }
    
    //For Fields Validation
    func fieldsValidation () {
        let email = emailTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passWordTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let apiLogin = "http://192.168.0.108/ask_question_poll/api/public/api/loginForUser"
        
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
        
        loginAPI(email: email, password: password, url: apiLogin)
        
    }
    
    //API Call
    func loginAPI(email: String, password: String , url: String) {
        let waitAlert = alert.showWait("Please Wait", subTitle: "",colorStyle: 0xFFEB3B)
        APIManager.sharedInstance.login(email: email, password: password, url: url) { response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                waitAlert.close()
                switch response {
                case .success(let response):
                    if response.code == 200 {
                        showSuccess(response.message ?? "Login Successfully")
                    } else {
                        showError(response.message ?? "Something went wrong")
                    }
                case .failure(let error):
                    showError("Something went wrong")
                }
            }
        }
    }
    
    //button action forgotpassword
    @IBAction func btnForgotPassword(_ sender: Any) {
//        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "OTPScreenVIewController") as! OTPScreenVIewController
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "SetPasswordViewController") as! SetPasswordViewController
//        vc.isForgotPassword = true
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "SignUpScreenViewController") as! SignUpScreenViewController
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
    
    
}
